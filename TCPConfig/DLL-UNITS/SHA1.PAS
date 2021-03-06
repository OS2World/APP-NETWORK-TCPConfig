unit SHA1;

(*************************************************************************

 DESCRIPTION     :  SHA1 - 160 bit Secure Hash Function

 REQUIREMENTS    :  TP5-7, D1-D6, FPC, VP (386+, undef BASM16 for 286)

 EXTERNAL DATA   :  ---

 MEMORY USAGE    :  ---

 DISPLAY MODE    :  ---

 REFERENCES      :  http://csrc.nist.gov/fips/fip180-1.pdf
                    http://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf


 Version  Date      Author      Modification
 -------  --------  -------     ------------------------------------------
 1.00     03.01.02  W.Ehrhardt  BP7 implementation
 1.01     14.03.02  we          D1-D6, FPC, VP
 1.02     14.03.02  we          TP6
 1.03     14.03.02  we          TP6/7 386-Code
 1.04     14.03.02  we          TP5.5
 1.10     15.03.02  we          self test with 2 strings
 1.11     02.01.03  we          const SFA with @ for FPC 1.0.6
 1.20     23.07.03  we          With SHA1File, SHA1Full
 1.21     26.07.03  we          With SHA1Full in self test
 2.00     26.07.03  we          common vers., longint for word32, D4+ - warnings
 2.01     03.08.03  we          type TSHA1Block for HMAC
 2.02     23.08.03  we          SHA1Compress in interface for prng
 2.10     29.08.03  we          XL versions for Win32
 2.20     27.09.03  we          FPC/go32v2
 2.30     05.10.03  we          STD.INC, TP5.0
 2.40     10.10.03  we          common version, english comments
 2.45     11.10.03  we          Speedup: partial unroll, no function calls
 2.50     16.11.03  we          Speedup in update, don't clear W in compress
 2.51     17.11.03  we          BIT16: partial unroll, BIT32: inline rot
 2.52     17.11.03  we          ExpandMessageBlocks
 2.53     18.11.03  we          LRot32, RB mit inline()
 2.54     20.11.03  we          Full range UpdateLen
 2.55     30.11.03  we          BIT16: {$F-}
 2.56     30.11.03  we          BIT16: LRot_5, LRot_30
 3.00     01.12.03  we          Common version 3.0
 3.01     22.12.03  we          BIT16: Two INCs
 3.02     22.12.03  we          BASM16: asm Lrot30
 3.03     22.12.03  we          TP5/5.5: LRot, RA inline
 3.04     22,12.03  we          Changed UpdateLen: Definition and TP5/5.5 inline
 3.05     05.03.04  we          Update fips180-2 URL
**************************************************************************)


(*-------------------------------------------------------------------------
 (C) Copyright 2002-2004 Wolfgang Ehrhardt

 This software is provided 'as-is', without any express or implied warranty.
 In no event will the authors be held liable for any damages arising from
 the use of this software.

 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it
 freely, subject to the following restrictions:

 1. The origin of this software must not be misrepresented; you must not
    claim that you wrote the original software. If you use this software in
    a product, an acknowledgment in the product documentation would be
    appreciated but is not required.

 2. Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.

 3. This notice may not be removed or altered from any source distribution.
----------------------------------------------------------------------------*)

{NOTE: FIPS Ch and May functions can be optimized. Wei-Dei (Crypto++ 3.1)
credits Rich Schroeppel (rcs@cs.arizona.edu), V 5.1 does not!?}


{$i STD.INC}


interface


type
  TSHA1Hash   = array[0..4] of longint;
  TSHA1Digest = array[0..19] of byte;
  TSHA1Block  = array[0..63] of byte;
  TSHA1Context= record
                  Hash    : TSHA1Hash;            {Working hash}
                  LHi,LLo : longint;              {64 bit message length}
                  Buffer  : TSHA1Block;           {Block buffer}
                  Index   : integer;              {Index in buffer}
                end;


procedure SHA1Init(var Context: TSHA1Context);
  {-initialize context}
  {$ifdef DLL} stdcall; {$endif}

procedure SHA1Update(var Context: TSHA1Context; Msg: pointer; Len: word);
  {-update context with Msg data}
  {$ifdef DLL} stdcall; {$endif}

procedure SHA1Final(var Context: TSHA1Context; var Digest: TSHA1Digest);
  {-finalize SHA1 calculation, clear context}
  {$ifdef DLL} stdcall; {$endif}

function  SHA1SelfTest: boolean;
  {-self test for string from SHA1 document}
  {$ifdef DLL} stdcall; {$endif}

procedure SHA1Full(var Digest: TSHA1Digest; Msg: pointer; Len: word);
  {-SHA1 of Msg with init/update/final}
  {$ifdef DLL} stdcall; {$endif}

procedure SHA1File(fname: string; var Digest: TSHA1Digest; var buf; bsize: word; var Err: word);
  {-SHA1 of file, buf: buffer with at least bsize bytes}
  {$ifdef DLL} stdcall; {$endif}

procedure SHA1Compress(var Data: TSHA1Context);
  {-Actual hashing function}
  {$ifdef DLL} stdcall; {$endif}

{$ifdef WIN32}
procedure SHA1UpdateXL(var Context: TSHA1Context; Msg: pointer; Len: longint);
  {-update context with Msg data}
  {$ifdef DLL} stdcall; {$endif}

procedure SHA1FullXL(var Digest: TSHA1Digest; Msg: pointer; Len: longint);
  {-SHA1 of Msg with init/update/final}
  {$ifdef DLL} stdcall; {$endif}
{$endif}

implementation

{$ifdef BIT16}
  {$F-}
{$endif}

{Internal types}
type
  TW32Buf  = array[0..15] of longint;
  TWorkBuf = array[0..79] of longint;
  PByte    = ^byte;


{$ifdef BIT32}

{---------------------------------------------------------------------------}
function RB(A: longint): longint; assembler;
  {-reverse byte order in longint}
asm
  {$ifdef LoadArgs}
    mov eax,[A]
  {$endif}
    xchg al,ah
    rol  eax,16
    xchg al,ah
end;


{---------------------------------------------------------------------------}
procedure UpdateLen(var whi, wlo: longint; BLen: longint);
  {-Add BLen to 64 bit value (wlo, whi)}
begin
  asm
    mov  edx, [wlo]
    mov  ecx, [whi]
    mov  eax, [Blen]
    add  [edx], eax
    adc  dword ptr [ecx], 0
  end;
end;


{---------------------------------------------------------------------------}
procedure ExpandMessageBlocks(var W: TWorkBuf; var Buf: TSHA1Block); assembler;
  {-Calculate "expanded message blocks"}
asm
     push  ebx
  {$ifdef LoadArgs}
     mov   ebx,[W]
     mov   edx,[Buf]
  {$else}
     mov   ebx,eax
  {$endif}
     {part1: W[i]:= RB(TW32Buf(Buf)[i])}
     mov   ecx,16
@@1: mov   eax,[edx]
     xchg  al,ah
     rol   eax,16
     xchg  al,ah
     mov   [ebx],eax
     add   ebx,4
     add   edx,4
     dec   ecx
     jnz   @@1
     {part2: W[i]:= LRot_1(W[i-3] xor W[i-8] xor W[i-14] xor W[i-16]);}
     mov   ecx,64
@@2: mov   eax,[ebx- 3*4]
     xor   eax,[ebx- 8*4]
     xor   eax,[ebx-14*4]
     xor   eax,[ebx-16*4]
     rol   eax,1
     mov   [ebx],eax
     add   ebx,4
     dec   ecx
     jnz   @@2
     pop   ebx
end;

{$else}




{$ifdef BASM16}

{TP5-7/Delphi1 for 386+}

{---------------------------------------------------------------------------}
procedure UpdateLen(var whi, wlo: longint; BLen: longint); assembler;
  {-Add BLen to 64 bit value (wlo, whi)}
asm
          les   di,[wlo]
  db $66; mov   ax,word ptr [BLen]
  db $66; sub   dx,dx
  db $66; add   es:[di],ax
          les   di,[whi]
  db $66; adc   es:[di],dx
end;


{---------------------------------------------------------------------------}
function LRot_5(x: longint): longint;
  {-Rotate left 5}
inline(
  $66/$58/          {pop    eax    }
  $66/$C1/$C0/$05/  {rol    eax,5  }
  $66/$8B/$D0/      {mov    edx,eax}
  $66/$C1/$EA/$10); {shr    edx,16 }


{---------------------------------------------------------------------------}
function RB(A: longint): longint;
  {-reverse byte order in longint}
inline(
    $58/            {pop    ax     }
    $5A/            {pop    dx     }
    $86/$C6/        {xchg   dh,al  }
    $86/$E2);       {xchg   dl,ah  }


{---------------------------------------------------------------------------}
procedure ExpandMessageBlocks(var W: TWorkBuf; var Buf: TSHA1Block); assembler;
  {-Calculate "expanded message blocks"}
asm
             push  ds
             {part 1: W[i]:= RB(TW32Buf(Buf)[i])}
             les   di,[Buf]
             lds   si,[W]
             mov   cx,16
@@1: db $66; mov   ax,es:[di]
             xchg  al,ah
     db $66; rol   ax,16
             xchg  al,ah
     db $66; mov   [si],ax
             add   si,4
             add   di,4
             dec   cx
             jnz   @@1
             {part 2: W[i]:= LRot_1(W[i-3] xor W[i-8] xor W[i-14] xor W[i-16]);}
             mov   cx,64
@@2: db $66; mov   ax,[si- 3*4]
     db $66; xor   ax,[si- 8*4]
     db $66; xor   ax,[si-14*4]
     db $66; xor   ax,[si-16*4]
     db $66; rol   ax,1
     db $66; mov   [si],ax
             add   si,4
             dec   cx
             jnz   @@2
             pop   ds
end;


{$else}

{TP5/5.5}

{---------------------------------------------------------------------------}
procedure UpdateLen(var whi, wlo: longint; BLen: longint);
  {-Add BLen to 64 bit value (wlo, whi)}
inline(
  $58/                 {pop  ax           }
  $5A/                 {pop  dx           }
  $5B/                 {pop  bx           }
  $07/                 {pop  es           }
  $26/$01/$07/         {add  es:[bx],ax   }
  $26/$11/$57/$02/     {adc  es:[bx+02],dx}
  $5B/                 {pop  bx           }
  $07/                 {pop  es           }
  $26/$83/$17/$00/     {adc  es:[bx],0    }
  $26/$83/$57/$02/$00);{adc  es:[bx+02],0 }


{---------------------------------------------------------------------------}
function RB(A: longint): longint;
  {-reverse byte order in longint}
inline(
  $58/          { pop  ax   }
  $5A/          { pop  dx   }
  $86/$C6/      { xchg dh,al}
  $86/$E2);     { xchg dl,ah}


{---------------------------------------------------------------------------}
function LRot_1(x: longint): longint;
  {-Rotate left 1}
inline(
  $58/          { pop  ax   }
  $5A/          { pop  dx   }
  $2B/$C9/      { sub  cx,cx}
  $D1/$D0/      { rcl  ax,1 }
  $D1/$D2/      { rcl  dx,1 }
  $13/$C1);     { adc  ax,cx}


{---------------------------------------------------------------------------}
function LRot_5(x: longint): longint;
  {-Rotate left 5}
inline(
  $58/          { pop  ax   }
  $5A/          { pop  dx   }
  $2B/$C9/      { sub  cx,cx}
  $D1/$D0/      { rcl  ax,1 }
  $D1/$D2/      { rcl  dx,1 }
  $13/$C1/      { adc  ax,cx}
  $D1/$D0/      { rcl  ax,1 }
  $D1/$D2/      { rcl  dx,1 }
  $13/$C1/      { adc  ax,cx}
  $D1/$D0/      { rcl  ax,1 }
  $D1/$D2/      { rcl  dx,1 }
  $13/$C1/      { adc  ax,cx}
  $D1/$D0/      { rcl  ax,1 }
  $D1/$D2/      { rcl  dx,1 }
  $13/$C1/      { adc  ax,cx}
  $D1/$D0/      { rcl  ax,1 }
  $D1/$D2/      { rcl  dx,1 }
  $13/$C1);     { adc  ax,cx}


{---------------------------------------------------------------------------}
function LRot_30(x: longint): longint;
  {-Rotate left 30 = rot right 2}
inline(
  $58/          { pop  ax   }
  $5A/          { pop  dx   }
  $8B/$CA/      { mov  cx,dx}
  $D1/$E9/      { shr  cx,1 }
  $D1/$D8/      { rcr  ax,1 }
  $D1/$DA/      { rcr  dx,1 }
  $8B/$CA/      { mov  cx,dx}
  $D1/$E9/      { shr  cx,1 }
  $D1/$D8/      { rcr  ax,1 }
  $D1/$DA);     { rcr  dx,1 }

{---------------------------------------------------------------------------}
procedure ExpandMessageBlocks(var W: TWorkBuf; var Buf: TSHA1Block);
  {-Calculate "expanded message blocks"}
var
  i: integer;
begin
  {Part 1: Transfer buffer with little -> big endian conversion}
  for i:=  0 to 15 do W[i]:= RB(TW32Buf(Buf)[i]);
  {Part 2: Calculate remaining "expanded message blocks"}
  for i:= 16 to 79 do W[i]:= LRot_1(W[i-3] xor W[i-8] xor W[i-14] xor W[i-16]);
end;

{$endif BASM16}

{$endif BIT32}


{$ifdef D4Plus}
  {$warnings off}
{$endif}


{$ifdef BIT32}


{---------------------------------------------------------------------------}
procedure SHA1Compress(var Data: TSHA1Context);
  {-Actual hashing function}
var
  i: integer;
  A, B, C, D, E: longint;
  W: TWorkBuf;
begin

  ExpandMessageBlocks(W, Data.Buffer);

  A := Data.Hash[0];
  B := Data.Hash[1];
  C := Data.Hash[2];
  D := Data.Hash[3];
  E := Data.Hash[4];

  {SHA1 compression function}
  {Partial unroll for more speed, full unroll is only slightly faster}
  {BIT32: rotateleft via inline}
  i := 0;
  while i<20 do begin
    inc(E, (A shl 5 or A shr 27) + (D xor (B and (C xor D))) + W[i  ] + $5A827999); B := B shr 2 or B shl 30;
    inc(D, (E shl 5 or E shr 27) + (C xor (A and (B xor C))) + W[i+1] + $5A827999); A := A shr 2 or A shl 30;
    inc(C, (D shl 5 or D shr 27) + (B xor (E and (A xor B))) + W[i+2] + $5A827999); E := E shr 2 or E shl 30;
    inc(B, (C shl 5 or C shr 27) + (A xor (D and (E xor A))) + W[i+3] + $5A827999); D := D shr 2 or D shl 30;
    inc(A, (B shl 5 or B shr 27) + (E xor (C and (D xor E))) + W[i+4] + $5A827999); C := C shr 2 or C shl 30;
    inc(i,5);
  end;
  while i<40 do begin
    inc(E, (A shl 5 or A shr 27) + (D xor B xor C) + W[i  ] + $6ED9EBA1); B := B shr 2 or B shl 30;
    inc(D, (E shl 5 or E shr 27) + (C xor A xor B) + W[i+1] + $6ED9EBA1); A := A shr 2 or A shl 30;
    inc(C, (D shl 5 or D shr 27) + (B xor E xor A) + W[i+2] + $6ED9EBA1); E := E shr 2 or E shl 30;
    inc(B, (C shl 5 or C shr 27) + (A xor D xor E) + W[i+3] + $6ED9EBA1); D := D shr 2 or D shl 30;
    inc(A, (B shl 5 or B shr 27) + (E xor C xor D) + W[i+4] + $6ED9EBA1); C := C shr 2 or C shl 30;
    inc(i,5);
  end;
  while i<60 do begin
    inc(E, (A shl 5 or A shr 27) + ((B and C) or (D and (B or C))) + W[i  ] + $8F1BBCDC); B := B shr 2 or B shl 30;
    inc(D, (E shl 5 or E shr 27) + ((A and B) or (C and (A or B))) + W[i+1] + $8F1BBCDC); A := A shr 2 or A shl 30;
    inc(C, (D shl 5 or D shr 27) + ((E and A) or (B and (E or A))) + W[i+2] + $8F1BBCDC); E := E shr 2 or E shl 30;
    inc(B, (C shl 5 or C shr 27) + ((D and E) or (A and (D or E))) + W[i+3] + $8F1BBCDC); D := D shr 2 or D shl 30;
    inc(A, (B shl 5 or B shr 27) + ((C and D) or (E and (C or D))) + W[i+4] + $8F1BBCDC); C := C shr 2 or C shl 30;
    inc(i,5);
  end;
  while i<80 do begin
    inc(E, (A shl 5 or A shr 27) + (D xor B xor C) + W[i  ] + $CA62C1D6); B := B shr 2 or B shl 30;
    inc(D, (E shl 5 or E shr 27) + (C xor A xor B) + W[i+1] + $CA62C1D6); A := A shr 2 or A shl 30;
    inc(C, (D shl 5 or D shr 27) + (B xor E xor A) + W[i+2] + $CA62C1D6); E := E shr 2 or E shl 30;
    inc(B, (C shl 5 or C shr 27) + (A xor D xor E) + W[i+3] + $CA62C1D6); D := D shr 2 or D shl 30;
    inc(A, (B shl 5 or B shr 27) + (E xor C xor D) + W[i+4] + $CA62C1D6); C := C shr 2 or C shl 30;
    inc(i,5);
  end;

  {Calculate new working hash}
  inc(Data.Hash[0], A);
  inc(Data.Hash[1], B);
  inc(Data.Hash[2], C);
  inc(Data.Hash[3], D);
  inc(Data.Hash[4], E);
end;


{$else}

{$ifdef BASM16}

{---------------------------------------------------------------------------}
procedure SHA1Compress(var Data: TSHA1Context);
  {-Actual hashing function}
var
  i: integer;
  A, B, C, D, E: longint;
  W: TWorkBuf;
begin
  ExpandMessageBlocks(W, Data.Buffer);
  {Assign old working hash to variables A..E}
  A := Data.Hash[0];
  B := Data.Hash[1];
  C := Data.Hash[2];
  D := Data.Hash[3];
  E := Data.Hash[4];

  {SHA1 compression function}
  {Partial unroll for more speed, full unroll only marginally faster}
  {Two INCs, LRot_30 via BASM}
  i := 0;
  while i<20 do begin
    inc(E,LRot_5(A)); inc(E,(D xor (B and (C xor D))) + W[i  ] + $5A827999); asm db $66; rol word[B],30 end;
    inc(D,LRot_5(E)); inc(D,(C xor (A and (B xor C))) + W[i+1] + $5A827999); asm db $66; rol word[A],30 end;
    inc(C,LRot_5(D)); inc(C,(B xor (E and (A xor B))) + W[i+2] + $5A827999); asm db $66; rol word[E],30 end;
    inc(B,LRot_5(C)); inc(B,(A xor (D and (E xor A))) + W[i+3] + $5A827999); asm db $66; rol word[D],30 end;
    inc(A,LRot_5(B)); inc(A,(E xor (C and (D xor E))) + W[i+4] + $5A827999); asm db $66; rol word[C],30 end;
    inc(i,5);
  end;
  while i<40 do begin
    inc(E,LRot_5(A)); inc(E,(B xor C xor D) + W[i  ] + $6ED9EBA1); asm db $66; rol word[B],30 end;
    inc(D,LRot_5(E)); inc(D,(A xor B xor C) + W[i+1] + $6ED9EBA1); asm db $66; rol word[A],30 end;
    inc(C,LRot_5(D)); inc(C,(E xor A xor B) + W[i+2] + $6ED9EBA1); asm db $66; rol word[E],30 end;
    inc(B,LRot_5(C)); inc(B,(D xor E xor A) + W[i+3] + $6ED9EBA1); asm db $66; rol word[D],30 end;
    inc(A,LRot_5(B)); inc(A,(C xor D xor E) + W[i+4] + $6ED9EBA1); asm db $66; rol word[C],30 end;
    inc(i,5);
  end;
  while i<60 do begin
    inc(E,LRot_5(A)); inc(E,((B and C) or (D and (B or C))) + W[i  ] + $8F1BBCDC); asm db $66; rol word[B],30 end;
    inc(D,LRot_5(E)); inc(D,((A and B) or (C and (A or B))) + W[i+1] + $8F1BBCDC); asm db $66; rol word[A],30 end;
    inc(C,LRot_5(D)); inc(C,((E and A) or (B and (E or A))) + W[i+2] + $8F1BBCDC); asm db $66; rol word[E],30 end;
    inc(B,LRot_5(C)); inc(B,((D and E) or (A and (D or E))) + W[i+3] + $8F1BBCDC); asm db $66; rol word[D],30 end;
    inc(A,LRot_5(B)); inc(A,((C and D) or (E and (C or D))) + W[i+4] + $8F1BBCDC); asm db $66; rol word[C],30 end;
    inc(i,5);
  end;
  while i<80 do begin
    inc(E,LRot_5(A)); inc(E,(B xor C xor D) + W[i  ] + $CA62C1D6); asm db $66; rol word[B],30 end;
    inc(D,LRot_5(E)); inc(D,(A xor B xor C) + W[i+1] + $CA62C1D6); asm db $66; rol word[A],30 end;
    inc(C,LRot_5(D)); inc(C,(E xor A xor B) + W[i+2] + $CA62C1D6); asm db $66; rol word[E],30 end;
    inc(B,LRot_5(C)); inc(B,(D xor E xor A) + W[i+3] + $CA62C1D6); asm db $66; rol word[D],30 end;
    inc(A,LRot_5(B)); inc(A,(C xor D xor E) + W[i+4] + $CA62C1D6); asm db $66; rol word[C],30 end;
    inc(i,5);
  end;

  {Calculate new working hash}
  inc(Data.Hash[0], A);
  inc(Data.Hash[1], B);
  inc(Data.Hash[2], C);
  inc(Data.Hash[3], D);
  inc(Data.Hash[4], E);

end;

{$else}

{TP5/5.5}
{---------------------------------------------------------------------------}
procedure SHA1Compress(var Data: TSHA1Context);
  {-Actual hashing function}
var
  i: integer;
  A, B, C, D, E: longint;
  W: TWorkBuf;
begin
  ExpandMessageBlocks(W, Data.Buffer);

  {Assign old working hash to variables A..E}
  A := Data.Hash[0];
  B := Data.Hash[1];
  C := Data.Hash[2];
  D := Data.Hash[3];
  E := Data.Hash[4];

  {SHA1 compression function}
  {Partial unroll for more speed, full unroll only marginally faster}
  {BIT16: rotateleft via function call}
  i := 0;
  while i<20 do begin
    inc(E,LRot_5(A) + (D xor (B and (C xor D))) + W[i  ] + $5A827999); B := LRot_30(B);
    inc(D,LRot_5(E) + (C xor (A and (B xor C))) + W[i+1] + $5A827999); A := LRot_30(A);
    inc(C,LRot_5(D) + (B xor (E and (A xor B))) + W[i+2] + $5A827999); E := LRot_30(E);
    inc(B,LRot_5(C) + (A xor (D and (E xor A))) + W[i+3] + $5A827999); D := LRot_30(D);
    inc(A,LRot_5(B) + (E xor (C and (D xor E))) + W[i+4] + $5A827999); C := LRot_30(C);
    inc(i,5);
  end;
  while i<40 do begin
    inc(E,LRot_5(A) + (B xor C xor D) + W[i  ] + $6ED9EBA1); B := LRot_30(B);
    inc(D,LRot_5(E) + (A xor B xor C) + W[i+1] + $6ED9EBA1); A := LRot_30(A);
    inc(C,LRot_5(D) + (E xor A xor B) + W[i+2] + $6ED9EBA1); E := LRot_30(E);
    inc(B,LRot_5(C) + (D xor E xor A) + W[i+3] + $6ED9EBA1); D := LRot_30(D);
    inc(A,LRot_5(B) + (C xor D xor E) + W[i+4] + $6ED9EBA1); C := LRot_30(C);
    inc(i,5);
  end;
  while i<60 do begin
    inc(E,LRot_5(A) + ((B and C) or (D and (B or C))) + W[i  ] + $8F1BBCDC); B := LRot_30(B);
    inc(D,LRot_5(E) + ((A and B) or (C and (A or B))) + W[i+1] + $8F1BBCDC); A := LRot_30(A);
    inc(C,LRot_5(D) + ((E and A) or (B and (E or A))) + W[i+2] + $8F1BBCDC); E := LRot_30(E);
    inc(B,LRot_5(C) + ((D and E) or (A and (D or E))) + W[i+3] + $8F1BBCDC); D := LRot_30(D);
    inc(A,LRot_5(B) + ((C and D) or (E and (C or D))) + W[i+4] + $8F1BBCDC); C := LRot_30(C);
    inc(i,5);
  end;
  while i<80 do begin
    inc(E,LRot_5(A) + (B xor C xor D) + W[i  ] + $CA62C1D6); B := LRot_30(B);
    inc(D,LRot_5(E) + (A xor B xor C) + W[i+1] + $CA62C1D6); A := LRot_30(A);
    inc(C,LRot_5(D) + (E xor A xor B) + W[i+2] + $CA62C1D6); E := LRot_30(E);
    inc(B,LRot_5(C) + (D xor E xor A) + W[i+3] + $CA62C1D6); D := LRot_30(D);
    inc(A,LRot_5(B) + (C xor D xor E) + W[i+4] + $CA62C1D6); C := LRot_30(C);
    inc(i,5);
  end;

  {Calculate new working hash}
  inc(Data.Hash[0], A);
  inc(Data.Hash[1], B);
  inc(Data.Hash[2], C);
  inc(Data.Hash[3], D);
  inc(Data.Hash[4], E);

end;

{$endif}


{$endif}



{---------------------------------------------------------------------------}
procedure SHA1Init(var Context: TSHA1Context);
  {-initialize context}
const
  SIV: TSHA1Hash = ($67452301, $EFCDAB89, $98BADCFE, $10325476, $C3D2E1F0);
begin
  {Clear context, buffer=0!!}
  fillchar(Context,sizeof(Context),0);
  Context.Hash := SIV;
end;



{$ifdef D4Plus}
  {$warnings on}
{$endif}


{---------------------------------------------------------------------------}
procedure SHA1UpdateXL(var Context: TSHA1Context; Msg: pointer; Len: longint);
   {-update context with Msg data}
const
  SIZE = sizeof(TSHA1Block);
var
  i: integer;
begin
  {Update message bit length}
  if Len<=$1FFFFFFF then UpdateLen(Context.LHi, Context.LLo, Len shl 3)
  else begin
    for i:=1 to 8 do UpdateLen(Context.LHi, Context.LLo, Len)
  end;
  while Len > 0 do begin
    {fill block with msg data}
    Context.Buffer[Context.Index]:= PByte(Msg)^;
    inc(longint(Msg));    {V1.4}
    inc(Context.Index);
    dec(Len);
    if Context.Index=SIZE then begin
      {If 512 bit transferred, compress a block}
      Context.Index:= 0;
      SHA1Compress(Context);
      while Len>=SIZE do begin
        move(Msg^,Context.Buffer,SIZE);
        SHA1Compress(Context);
        inc(longint(Msg),SIZE);
        dec(Len,SIZE);
      end;
    end;
  end;
end;


{---------------------------------------------------------------------------}
procedure SHA1Update(var Context: TSHA1Context; Msg: pointer; Len: word);
   {-update context with Msg data}
begin
  SHA1UpdateXL(Context, Msg, Len);
end;



{---------------------------------------------------------------------------}
procedure SHA1Final(var Context: TSHA1Context; var Digest: TSHA1Digest);
  {-finalize SHA1 calculation, clear context}
var
  i: integer;
begin
  {Message padding}
  {1. append bit '1' after msg}
  Context.Buffer[Context.Index]:= $80;
  for i:=Context.Index+1 to 63 do Context.Buffer[i] := 0;
  {2. Compress if more than 448 bits, (no room for 64 bit length}
  if Context.Index>= 56 then begin
    SHA1Compress(Context);
    fillchar(Context.Buffer,56,0);
  end;
  {Write 64 bit msg length into the last bits of the last block}
  {(in big endian format) and do a final compress}
  TW32Buf(Context.Buffer)[14] := RB(Context.LHi);
  TW32Buf(Context.Buffer)[15] := RB(Context.LLo);
  SHA1Compress(Context);
  {Hash->Digest to little endian format}
  for i:=0 to 4 do TSHA1Hash(Digest)[i]:= RB(Context.Hash[i]);
  {Clear context}
  fillchar(Context,sizeof(Context),0);
end;


{---------------------------------------------------------------------------}
function SHA1SelfTest: boolean;
  {-self test for string from SHA1 document}
const
  s1: string[ 3] = 'abc';
  s2: string[56] = 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq';
  D1: TSHA1Digest= ($a9,$99,$3e,$36,$47,$06,$81,$6a,$ba,$3e,$25,$71,$78,$50,$c2,$6c,$9c,$d0,$d8,$9d);
  D2: TSHA1Digest= ($84,$98,$3E,$44,$1C,$3B,$D2,$6E,$BA,$AE,$4A,$A1,$F9,$51,$29,$E5,$E5,$46,$70,$F1);


  function SingleTest(s: string; TDig: TSHA1Digest): boolean;
    {-do a single test, const not allowed for VER<7}
    { Two sub tests: 1. whole string, 2. one update per char}
  var
    Context: TSHA1Context;
    Digest: TSHA1Digest;
    i: integer;
  begin
    {1. Hash complete string}
    SHA1Full(Digest, @s[1],length(s));
    {Compare with known value}
    for i:=0 to sizeof(Digest)-1 do begin
      if Digest[i]<>TDig[i] then begin
        SingleTest := false;
        exit;
      end;
    end;
    {2. one update call for all chars}
    SHA1Init(Context);
    for i:=1 to length(s) do SHA1Update(Context,@s[i],1);
    SHA1Final(Context,Digest);
    {Compare with known value}
    for i:=0 to sizeof(Digest)-1 do begin
      if Digest[i]<>TDig[i] then begin
        SingleTest := false;
        exit;
      end;
    end;
    SingleTest := true;
  end;

begin
  SHA1SelfTest := SingleTest(s1, D1) and SingleTest(s2, D2);
end;



{---------------------------------------------------------------------------}
procedure SHA1FullXL(var Digest: TSHA1Digest; Msg: pointer; Len: longint);
  {-SHA1 of Msg with init/update/final}
var
  Context: TSHA1Context;
begin
  SHA1Init(Context);
  SHA1UpdateXL(Context, Msg, Len);
  SHA1Final(Context, Digest);
end;


{---------------------------------------------------------------------------}
procedure SHA1Full(var Digest: TSHA1Digest; Msg: pointer; Len: word);
  {-SHA1 of Msg with init/update/final}
begin
  SHA1FullXL(Digest, Msg, Len);
end;


{---------------------------------------------------------------------------}
procedure SHA1File(fname: string; var Digest: TSHA1Digest; var buf; bsize: word; var Err: word);
  {-SHA1 of file, buf: buffer with at least bsize bytes}
var
  Context: TSHA1Context;
  w: word;
  {$ifdef WIN32}
    L: longint;
  {$else}
    L: longint;
  {$endif}
  f: file;

begin
  w := FileMode;
  {$ifdef VirtualPascal}
    FileMode := $40; {open_access_ReadOnly or open_share_DenyNone;}
  {$else}
    FileMode := 0;
  {$endif}
  system.assign(f, fname);
  system.reset(f,1);
  Err := IOResult;
  FileMode := w;
  if Err<>0 then exit;
  SHA1Init(Context);
  while (Err=0) and not eof(f) do begin
    system.blockread(f,buf,bsize,L);
    Err := IOResult;
    SHA1Update(Context, @buf, L);
  end;
  system.close(f);
  if IOResult=0 then;
  SHA1Final(Context, Digest);
end;



end.

