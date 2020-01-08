program parametergrouping;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TBlockRec = record
    P: Pointer;
    origin : record x,y: Integer; end;
    size : record width,height:Integer; end;
    interlived : Boolean;
  end;


begin

end.
