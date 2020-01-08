program resultflow;

{$APPTYPE CONSOLE}

{$SCOPEDENUMS ON}

{$define EXCEPTION_ON_TODO}
uses
  System.SysUtils;



procedure ToDo(msg: string);
begin
{$ifdef EXCEPTION_ON_TODO}
  raise Exception.Create('msg');
{$endif}
end;



procedure SimpleMemoryOperation1(P: Pointer; Len: Integer);
var
  X: NativeInt;
begin
  for X := 0 to Len-1 do
    PByte(P)[X] := $0F
end;



procedure SimpleMemoryOperation2(P: Pointer; Len: Integer);
var
  X: NativeInt;
begin
  for X := 0 to Len-1 do
    PByte(P)[X] := $F0;
end;

type
  TMemoryOperation = (operation1, operation2);


function AdvancedMemoryOperation(P: Pointer; Len: Integer; OerationType: TMemoryOperation): Boolean;
begin
  if (P <> nil) and (Len > 0) then
    Result := True
  else Result := False;

  if Result then
  begin
    case OerationType of
      // set memory left 4 bits to one
      TMemoryOperation.operation1: SimpleMemoryOperation1(P,Len);
      // set memory right 4 bits to one
      TMemoryOperation.operation2: SimpleMemoryOperation2(P,Len);
      // illegal operation
      else Result := False;
    end;
  end;
end;


type
  TMemoryProcess = (process1, process2, process3, process4, process5, process6);
  TMemoryOperationResult = (Experemental = 1, OK = 0, Error = -1, Unimplemented = -2 );


function AdvancedMemoryProcessor(P: Pointer; Len: Integer; ProcessType: TMemoryProcess): TMemoryOperationResult;
  function OperationResult(success: Boolean): TMemoryOperationResult;
  begin
    if success then
      Result := TMemoryOperationResult.OK
    else Result := TMemoryOperationResult.Error;
  end;

begin
  case ProcessType of
    //
    TMemoryProcess.process1:
      Result := OperationResult(AdvancedMemoryOperation(P,Len,TMemoryOperation.operation1));

    //
    TMemoryProcess.process2:
      Result := OperationResult(AdvancedMemoryOperation(P,Len,TMemoryOperation.operation2));

    //
    TMemoryProcess.process3:
    begin
      if (P <> nil) and (Len > 0) then
      begin
        FillChar(P^,Len,$99);
        Result := TMemoryOperationResult.Experemental;
      end
      else Result := TMemoryOperationResult.Error;
    end;

    //
    else
    begin
      ToDo('ProcessType'+ProcessType+' not implemented');

      Result := TMemoryOperationResult.Unimplemented;
    end;
  end;

end;









begin

end.
