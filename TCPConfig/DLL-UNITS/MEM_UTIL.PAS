(*************************************************************************

 DESCRIPTION     :  Utility procedures for hex dump and memory compare

 REQUIREMENTS    :  TP5-7, D1-D6, FPC, VP

 EXTERNAL DATA   :  ---

 MEMORY USAGE    :  ---

 DISPLAY MODE    :  ---

 REFERENCES      :  RFC 3548 - The Base16, Base32, and Base64 Data Encodings


 Version  Date      Author      Modification
 -------  --------  -------     ------------------------------------------
 0.10     01.01.02  W.Ehrhardt  Initial version
 0.20     30.08.03  we          with pointer valid for all compilers
 0.30     17.09.03  we          with HexLong
 0.40     27.09.03  we          FPC/go32v2
 0.50     05.10.03  we          STD.INC
 0.60     10.10.03  we          english comments
 0.60     26.12.03  we          Base64Str
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

unit Mem_Util;

{$i STD.INC}

interface


function HexByte(b: byte): string;
  {-byte ss hex string}

function HexLong(L: longint): string;
  {-longint as hex string}

function HexStr(psrc: pointer; L: integer): string;
  {-hex string of memory block of length L pointed by psrc}

function Base64Str(psrc: pointer; L: integer): string;
  {-Base64 string of memory block of length L pointed by psrc}

function CompMem(psrc, pdest: pointer; size: word): boolean;
  {-compare memory block}


implementation

type
  pByte = ^byte;


{---------------------------------------------------------------------------}
function HexByte(b: byte): string;
  {-byte ss hex string}
const
  nib: array[0..15] of char = '0123456789abcdef';
begin
  HexByte := nib[b div 16] + nib[b and 15];
end;


{---------------------------------------------------------------------------}
function HexLong(L: longint): string;
  {-longint as hex string}
var
  i: integer;
  s: string[8];
begin
  s := '';
  for i:=0 to 3 do begin
    s := HexByte(L and $FF) + s;
    L := L shr 8;
  end;
  HexLong := s;
end;

{---------------------------------------------------------------------------}
function HexStr(psrc: pointer; L: integer): string;
  {-hex string of memory block of length L pointed by psrc}
var
  i: integer;
  s: string;
begin
  s := '';
  for i:=0 to L-1 do begin
    s := s + HexByte(pByte(psrc)^);
    inc(longint(psrc));
  end;
  HexStr := s;
end;


{---------------------------------------------------------------------------}
function Base64Str(psrc: pointer; L: integer): string;
  {-Base64 string of memory block of length L pointed by psrc}
const
  CTab: array[0..63] of char = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
var
  q,r: integer;
  b0,b1,b2: byte;
  s: string;
begin
  s := '';
  if L>0 then begin
    q := L div 3;
    r := L mod 3;
    while q>0 do begin
      b0 := pByte(psrc)^; inc(longint(psrc));
      b1 := pByte(psrc)^; inc(longint(psrc));
      b2 := pByte(psrc)^; inc(longint(psrc));
      s := s + CTab[(b0 shr 2) and $3f]
             + CTab[((b0 shl 4) and $30) or ((b1 shr 4) and $0f)]
             + CTab[((b1 shl 2) and $3c) or ((b2 shr 6) and $03)]
             + Ctab[b2 and $3f];
      dec(q);
    end;
    if r=2 then begin
      b0 := pByte(psrc)^; inc(longint(psrc));
      b1 := pByte(psrc)^;
      s := s + CTab[(b0 shr 2) and $3f]
             + CTab[((b0 shl 4) and $30) or ((b1 shr 4) and $0f)]
             + CTab[(b1 shl 2) and $3c]
             + '=';
    end
    else if r=1 then begin
      b0 := pByte(psrc)^;
      s := s + CTab[(b0 shr 2) and $3f] + CTab[(b0 shl 4) and $30] + '==';
    end;
  end;
  Base64Str := s;
end;


{---------------------------------------------------------------------------}
function CompMem(psrc, pdest: pointer; size: word): boolean;
  {-compare memory block}
var
  i: word;
begin
  CompMem := false;
  for i:=1 to size do begin
    if pByte(psrc)^<>pByte(pdest)^ then exit;
    inc(longint(psrc));
    inc(longint(pdest));
  end;
  CompMem := true;
end;

end.
