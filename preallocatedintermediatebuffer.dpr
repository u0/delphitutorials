program preallocatedintermediatebuffer;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;


type
  AlgoritnmMode = (simple, basic, medium, brutal);


procedure tileAlgorithmSpecSize(const mode: AlgoritnmMode; const width, height: Integer; pSpecSize: PInteger);
begin

end;

procedure tileAlgorithmInitOnce(const mode: AlgoritnmMode; const width, height: Integer; pSpec: Pointer);
begin

end;

procedure tileAlgorithmProcess(pSrcDst: Pointer; const srcDstStep, width, height: Integer; pSpec: Pointer);
begin

end;


procedure streamAlgorithmSpecSize(const mode: AlgoritnmMode; pTable: pInteger; tableItemCount: Integer; pSpecSize: PInteger);
begin

end;

procedure streamAlgorithmInitOnce(const mode: AlgoritnmMode; pTable: pInteger; tableItemCount: Integer; pSpec: Pointer);
begin

end;

procedure streamAlgorithmProcessCompress(const pSrc: Pointer; srcLen: Integer; ppDst: PPointer; const pSpec: Pointer);
begin

end;

procedure streamAlgorithmProcessUnCompress(ppSrc: PPointer; pDst: Pointer; dstLen: Integer; const pSpec: Pointer);
begin

end;




var
  ImgWidth: Integer = 1920;
  ImgHigh: Integer = 1080;

  ImgPitch: Integer;
  ImgData: PByte;

  streamData: PByte;

var
  tileWidth,tileHeight: Integer;
  tileSpecSize: Integer;
  tileSpec: Pointer;

var
  streamTable: array[0..1023] of Integer;
  streamSpecSize: Integer;
  streamSpec: Pointer;

var
  tX,tY: NativeInt;

begin
  // alloc memory for image
  ImgPitch := ((ImgWidth + 3) div 4) * 4;
  GetMem(ImgData,ImgPitch*ImgHigh);

  GetMem(streamData,ImgPitch*ImgHigh);

  // alloc buffer for tile processing
  tileWidth := 8;
  tileHeight := 8;

  //
  tileAlgorithmSpecSize(simple,tileWidth,tileHeight,@tileSpecSize);

  GetMem(tileSpec,tileSpecSize);
  tileAlgorithmInitOnce(simple,tileWidth,tileHeight,tileSpec);

  // process image by tiles using same external buffer.
  for tY := 0 to (ImgHigh div tileHeight)-1 do
    for tX := 0 to (ImgWidth div tileWidth)-1 do
      tileAlgorithmProcess(
        @ImgData[tY*ImgPitch*tileHeight + tX*ImgWidth],ImgPitch,
        tileWidth,tileHeight,
        tileSpec
      );

  FreeMem(tileSpec);



  //
  streamAlgorithmSpecSize(brutal,@streamTable[0],Length(streamTable),@streamSpecSize);

  GetMem(streamSpec,streamSpecSize);
  streamAlgorithmInitOnce(brutal,@streamTable[0],Length(streamTable), streamSpec);


  streamAlgorithmProcessCompress(ImgData,ImgPitch*ImgHigh, @streamData, streamSpec);


  streamAlgorithmProcessUnCompress(@streamData, ImgData,ImgPitch*ImgHigh, streamSpec);


  FreeMem(streamSpec);


  // release memory
  FreeMem(ImgData);
  FreeMem(streamData);
end.
