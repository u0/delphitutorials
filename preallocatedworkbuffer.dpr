program preallocatedworkbuffer;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

procedure ProcessTile(const pSrc: Pointer; const srcStep: Integer; pDst: Pointer; const dstStep: Integer; const width,hight: Integer; pTmp: Pointer);
var
  X,Y, maxWidth, maxHight: NativeInt;
  pS,pD,pT: PByte;
begin
  maxWidth := width -1;
  maxHight := hight -1;

  pS := PByte(pSrc);
  pD := PByte(pDst);
  pT := PByte(pTmp);

  // first pass, using src and dst data, writing to tmp
  for Y := 0 to maxHight do
  begin

    for X := 0 to maxWidth do
      pT[X] := (pS[X] xor pD[X]) + X;

    Inc(pS,srcStep);
    Inc(pD,dstStep);

    Inc(pT,width);
  end;

  // second pass, using tmp and src data, writeng to dst
  for Y := 0 to maxHight do
  begin

    for X := 0 to maxWidth do
      pD[X] := pT[pS[X]];

    Inc(pS,srcStep);
    Inc(pD,dstStep);

    Inc(pT,width);
  end;

end;

procedure ProcessBlockSimple(const pSrc: Pointer; const srcStep: Integer; pDst: Pointer; const dstStep: Integer; const width,hight: Integer);
var
  X,Y, maxWidth, maxHight: NativeInt;
  pS,pD: PByte;
begin
  maxWidth := width -1;
  maxHight := hight -1;

  pS := PByte(pSrc);
  pD := PByte(pDst);

  // first pass, using src and dst data, writing to tmp
  for Y := 0 to maxHight do
  begin

    for X := 0 to maxWidth do
      pD[X] := (pS[X] xor pD[X]) + X;

    Inc(pS,srcStep);
    Inc(pD,dstStep);
  end;
end;
procedure ConvertColor(const pSrc: Pointer; const srcStep: Integer; pDst: Pointer; const dstStep: Integer; const width,hight: Integer);
var
  X,Y, maxWidth, maxHight: NativeInt;
  pS,pD: PByte;
begin
  maxWidth := width -1;
  maxHight := hight -1;

  pS := PByte(pSrc);
  pD := PByte(pDst);

  // first pass, using src and dst data, writing to tmp
  for Y := 0 to maxHight do
  begin

    for X := 0 to maxWidth do
      pD[X] := (pS[X] xor pD[X]) + X;

    Inc(pS,srcStep);
    Inc(pD,dstStep);
  end;
end;

procedure ProcessBlockAndConvertColor(const pSrc: Pointer; const srcStep: Integer; pDst: Pointer; const dstStep: Integer; const width,hight: Integer);
const
  cBufferMaxSize = 256;
var
  buffer: array[0..cBufferMaxSize-1] of Byte;
begin

  assert(width*hight <= cBufferMaxSize);

  ProcessBlockSimple(pSrc,srcStep, @buffer[0],width, width,hight);
  ConvertColor(@buffer[0],width, pDst,dstStep, width,hight);
end;


var
  ImgWidth: Integer = 1920;
  ImgHigh: Integer = 1080;

  ImgPitch: Integer;
  ImgData,ImgDataDst: PByte;

  tileWidth,tileHeight,tilePitch: Integer;
  tileBuffer: Pointer;

var
  tX,tY: NativeInt;

begin
  // alloc memory for image
  ImgPitch := ((ImgWidth + 3) div 4) * 4;

  GetMem(ImgData,ImgPitch*ImgHigh);
  GetMem(ImgDataDst,ImgPitch*ImgHigh);

  // alloc buffer for tile processing
  tileWidth := 32;
  tileHeight := 8;
  tilePitch := tileWidth;
  GetMem(tileBuffer,tilePitch*tileHeight);


  // process image by tiles using same external buffer.
  for tY := 0 to (ImgHigh div tileHeight)-1 do
    for tX := 0 to (ImgWidth div tileWidth)-1 do
      ProcessTile(
       @ImgData[tY*ImgPitch*tileHeight + tX*ImgWidth],ImgPitch,
       @ImgDataDst[tY*ImgPitch*tileHeight + tX*ImgWidth],ImgPitch,
       tileWidth,tileHeight,tileBuffer
       );



  // process image by tiles using intermidiate buffer.
  for tY := 0 to (ImgHigh div tileHeight)-1 do
    for tX := 0 to (ImgWidth div tileWidth)-1 do
    begin
      ProcessBlockSimple(
      @ImgData[tY*ImgPitch*tileHeight + tX*ImgWidth],ImgPitch,
      tileBuffer,tilePitch,
      tileWidth,tileHeight);

      ConvertColor(
      tileBuffer,tilePitch,
      @ImgDataDst[tY*ImgPitch*tileHeight + tX*ImgWidth],ImgPitch,
      tileWidth,tileHeight);
    end;


  // process image by tiles using intermidiate buffer.
  for tY := 0 to (ImgHigh div tileHeight)-1 do
    for tX := 0 to (ImgWidth div tileWidth)-1 do
    ProcessBlockAndConvertColor(
    @ImgData[tY*ImgPitch*tileHeight + tX*ImgWidth],ImgPitch,
    @ImgDataDst[tY*ImgPitch*tileHeight + tX*ImgWidth],ImgPitch,
    tileWidth,tileHeight);

  // release memory
  FreeMem(ImgData);
  FreeMem(ImgDataDst);
  FreeMem(tileBuffer);
end.
