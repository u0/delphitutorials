program primitiveunnecessaryusage;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TError = (OK = 0, Error = -1 );

function SimpePimitive(pSrc: PByte; scStep: Integer; pDst: PByte; dstStep: Integer; Width, Height: Integer): TError;
begin
  Result := Ok;
end;

// nomal bock is 8x8
procedure NormalBlockPimitive(pSrc: PByte; scStep: Integer; pDst: PByte; dstStep: Integer); inline;
type
{$POINTERMATH ON}
  P64u         = ^UInt64;
{$POINTERMATH OFF}
begin
  P64u(pDst)[dstStep*0] := P64u(pSrc)[scStep*0];
  P64u(pDst)[dstStep*1] := P64u(pSrc)[scStep*1];
  P64u(pDst)[dstStep*2] := P64u(pSrc)[scStep*2];
  P64u(pDst)[dstStep*3] := P64u(pSrc)[scStep*3];
  P64u(pDst)[dstStep*4] := P64u(pSrc)[scStep*4];
  P64u(pDst)[dstStep*5] := P64u(pSrc)[scStep*5];
  P64u(pDst)[dstStep*6] := P64u(pSrc)[scStep*6];
  P64u(pDst)[dstStep*7] := P64u(pSrc)[scStep*7];
end;


procedure LineOfBlockPimitive(pSrc: PByte; pDst: PByte; Width: Integer); inline;
type
  PUInt32 = ^UInt32;
begin
  case Width of
    1: PByte(pDst)^ := PByte(pSrc)^;
    2: PWord(pDst)^ := PWord(pSrc)^;
    4: PUInt32(pDst)^ := PUInt32(pSrc)^;
    8: PUInt64(pDst)^ := PUInt64(pSrc)^;
  else
    //raise Exception.Create('not implemented for width='+IntToStr(Width));
    Move(pSrc^, pDst^,Width);
  end;
end;

function genericBlockPimitive(pSrc: PByte; scStep: Integer; pDst: PByte; dstStep: Integer; Width, Height: Integer): Boolean; inline;
type
  PUInt32 = ^UInt32;
var
  H: NativeInt;
  pS,pD: PByte;
begin
  if (Width <= 8)then
  begin
    if (Width > 0) and (Height > 0)  then
    begin
       if (scStep = Width) and (dstStep = Width) then
          Move(pSrc^, pDst^, Width*Height)
       else
       begin
          pS := pSrc; pD := pDst;
          case Width of
            1: for H := 0 to Height-1 do begin PByte(pD)^ := PByte(pS)^; Inc(pS,scStep); Inc(pD,dstStep); end;
            2: for H := 0 to Height-1 do begin PWord(pD)^ := PWord(pS)^; Inc(pS,scStep); Inc(pD,dstStep); end;
            3: Result := False;
            4: for H := 0 to Height-1 do begin PUInt32(pD)^ := PUInt32(pS)^; Inc(pS,scStep); Inc(pD,dstStep); end;
            5: Result := False;
            6: Result := False;
            7: Result := False;
            8: for H := 0 to Height-1 do  begin PUInt64(pD)^ := PUInt64(pS)^; Inc(pS,scStep); Inc(pD,dstStep); end;
          end;
       end
    end
    else
     Result := False;

  end
  else Result :=  SimpePimitive() = OK;
end;





begin



end.
