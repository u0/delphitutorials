program alignedsrcdstbuffers;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;


procedure ProcessBlockSimple(const pSrc: Pointer; const srcStep: Integer; pDst: Pointer; const dstStep: Integer; const width,height: Integer);
var
  X,Y, maxWidth, maxHeight: NativeInt;
  pS,pD: PByte;
begin
  maxWidth := width -1;
  maxHeight := height -1;

  pS := PByte(pSrc);
  pD := PByte(pDst);

  // first pass, using src and dst data, writing to tmp
  for Y := 0 to maxHeight do
  begin

    for X := 0 to maxWidth do
      pD[X] := (pS[X] xor pD[X]) + X;

    Inc(pS,srcStep);
    Inc(pD,dstStep);
  end;
end;


var
  ImgWidth: Integer = 1920;
  ImgHigh: Integer = 1080;

  ImgPitch: Integer;
  ImgData,ImgDataDst: PByte;

  tileWidth,tileHeight: Integer;

  alignedImgData,alignedImgDataDst: PByte;

var
  tX,tY: NativeInt;

begin

  // alloc memory for image
  //ImgPitch := ((ImgWidth + 3) div 4) * 4;
  ImgPitch := ((ImgWidth + $0F) or $0F) xor $0F; // 16 byte padding is necessary?

  // get enough data to be aligned
  //  (getmem is usually aligned, but for demonstration purposes we asume that is not the case. this is good practice anyway.)
  GetMem(ImgData,ImgPitch*ImgHigh + 16);
  GetMem(ImgDataDst,ImgPitch*ImgHigh + 16);

  // align image buffer before usage.
  NativeUInt(alignedImgData) := ((NativeUInt(ImgData) + $0F) or $0F) xor $0F;
  NativeUInt(alignedImgDataDst) := ((NativeUInt(ImgDataDst) + $0F) or $0F) xor $0F;

  // alloc buffer for tile processing
  tileWidth := 32;  // this should be multiple of 16!
  tileHeight := 8;   // this may be any number.(because each number is inherantly muiltple of width)

  // process image by tiles using same external buffer.
  for tY := 0 to (ImgHigh div tileHeight)-1 do
    for tX := 0 to (ImgWidth div tileWidth)-1 do
      ProcessBlockSimple(
        @ImgData[tY*ImgPitch*tileHeight + tX*ImgWidth],ImgPitch,
        @ImgDataDst[tY*ImgPitch*tileHeight + tX*ImgWidth],ImgPitch,
        tileWidth,tileHeight
      );

  // release memory
  FreeMem(ImgData);
  FreeMem(ImgDataDst);
end.
