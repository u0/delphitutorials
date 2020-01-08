program memoryownership;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;


type
  PVideoStream = ^TVideoStream;
  TVideoStream  = record
  type
    TFrameType = (interlived, plalnar);
  var
    Width,Height,Pitch: Integer;
    ChannelCount: Integer;
    FrameType: TFrameType;
    FrameDataSize: Integer;
    ChannelOffset: array[0..3] of Integer;
    Buffer: Pointer;
  end;

function OpenStream(path: string; ppStream: PVideoStream): Boolean;
begin
  Result := True;
end;

function ReadFrame(pBuffer: Pointer; const bufferLen: Integer; pStream: PVideoStream): Boolean;
begin
  Result := True;
end;

function WriteFrame(pBuffer: Pointer; const bufferLen: Integer; pStream: PVideoStream): Boolean;
begin
  Result := True;
end;

procedure CloseStream(pStream: PVideoStream);
begin

end;


procedure ProcessImageSimple(const pSrc: Pointer; const srcStep: Integer; pDst: Pointer; const dstStep: Integer; const width,height: Integer);
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
  ImgData,alignedImgData: PByte;
  ImgDataLen: Integer;

  ImgDataDst,alignedImgDataDst: PByte;
  ImgDataDstLen: Integer;

var
  Stream: PVideoStream;

var
  channel: NativeInt;

begin
  ImgData := nil;
  ImgDataDst := nil;

  if OpenStream('network://videoserver/stream1', @Stream) then // stream record holds internal buffer for async handling, requiers proper memory release.
  try
    // alloc memory for image
    ImgDataLen := Stream^.FrameDataSize; // it is up to Stream-handler to do padding or strides, there nothing we can do here.

    // get enough data to be aligned
    //  (getmem is usually aligned, but for demonstration purposes we asume that is not the case. this is good practice anyway.)
    GetMem(ImgData,ImgDataLen + 16);
    NativeUInt(alignedImgData) := ((NativeUInt(ImgData) + $0F) or $0F) xor $0F;

    // same for destination
    ImgDataDstLen := Stream^.FrameDataSize;

    GetMem(ImgDataDst,Stream^.FrameDataSize + 16);
    NativeUInt(alignedImgDataDst) := ((NativeUInt(ImgDataDst) + $0F) or $0F) xor $0F;


    while ReadFrame(ImgData, ImgDataLen, Stream) do
    begin
      case Stream^.FrameType of
        interlived :
          for channel := 0 to Stream^.ChannelCount-1 do
            // Pitch might not be padded properly
            ProcessImageSimple(
              @alignedImgData[Stream^.ChannelOffset[channel]],Stream^.Pitch,
              @alignedImgDataDst[Stream^.ChannelOffset[channel]],Stream^.Pitch,
              Stream^.Width, Stream^.Height
            );

        plalnar :
          raise Exception.Create('plalnar handling is unimplemented!!!');

        else raise Exception.Create('FrameType is wrong!!!');
      end;

      // wite processed frame back
      WriteFrame(alignedImgDataDst, ImgDataDstLen, Stream);

    end;

  finally
    // release memory
    FreeMem(ImgData);
    FreeMem(ImgDataDst);
    // release stream
    CloseStream(Stream);
  end;

end.
