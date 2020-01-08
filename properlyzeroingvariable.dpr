program properlyzeroingvariable;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  PBlockInfo = ^TBlockInfo;
  TBlockInfo = record
    p_next : PBlockInfo;
    data: pointer;

    procedure Clear();
    // calss operator equal  ????
  end;

procedure TBlockInfo.Clear;
begin

end;

//procedure TBlockInfo.Equal;
//begin
//
//end;

type
  TDeltaBuffer = record
    //pTable: array of Integer; // not using anymore
    pTable: PInteger;
    pTableSize: Integer;

    pBufferTable: PPointer;

    procedure Free();
  end;
{ TDeltaBuffer }

procedure TDeltaBuffer.Free;
begin

end;


type
  TBlockConfig = record
    // list of relevant blocks
    pBlockList: PBlockInfo;
    // delatcoding buffers
    deltadata: TDeltaBuffer;

    X,Y: Integer;

    rd_param: Double;

    // block name for logging
    debugmsg: string;
  end;
  PBlockConfig = ^TBlockConfig;

var
  BlockConfig : PBlockConfig;


  procedure Reset(pBlockcfg: PBlockConfig);
  begin
    if pBlockcfg <> nil then
    begin
      pBlockcfg^.pBlockList.Clear;
      //pBlockcfg^.pBlockList = nil;

      pBlockcfg^.deltadata.Free;

      // now we can clear everithing else.
      pBlockcfg^ := Default(TBlockConfig);
    end;
  end;


begin
 GetMem(BlockConfig, SizeOf(TBlockConfig));

 Reset(BlockConfig);

end.
