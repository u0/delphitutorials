program optimaldataiteration;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function SATURATE(value: NativeUInt): Byte; inline;
begin
  if value <= Byte(-1) then
    Result := value
  else Result := Byte(-1);
end;


function SimpleSum(const buffer: PByte; bufferLen: Integer): NativeUInt;
var
  X: NativeInt;
  pB: PByte;
  Sum: NativeUInt;
begin
  assert( (NativeUInt(-1) shr 8) <= bufferLen);

  pB := buffer;

  Sum := 0;
  for X := 0 to bufferLen-1 do
    Inc(Sum, pB[X]);

  Result := Sum;
end;


procedure SimpleAddC(const pSrc: PByte; srcLen: Integer; pDst: PByte; dstLen: Integer; value: Byte);
var
  X: NativeInt;
  pS,pD: PByte;
  len: Integer;
begin

  pS := pSrc;
  pD := pDst;

  if srcLen > dstLen then
    len := dstLen
  else len := srcLen;

  for X := 0 to len-1 do
    pD[X] := SATURATE(pS[X] + value);

end;

procedure AddC(const pSrc: PByte; srcLen: Integer; pDst: PByte; dstLen: Integer; value: Byte; Width, Height);
var
  X: NativeInt;
  pS,pD: PByte;
  len: Integer;
begin

  pS := pSrc;
  pD := pDst;

  if srcLen > dstLen then
    len := dstLen
  else len := srcLen;

  for X := 0 to len-1 do
    pD[X] := SATURATE(pS[X] + value);

end;




begin



end.
