program localvariablesoptimalusage;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;


  function FastProcedure(P: Pointer; Len: Integer): Integer;
  var
    X,Y: NativeInt;
    tmp1, sum, count, median,max_len: NativeUint;
    p_cur,p_end: PByte;
  begin

    p_cur := P;
    p_end := p_cur + Len;

    median := 0;

    while p_cur < p_end do
    begin

      max_len := p_end - p_cur;

      if p_cur^ > max_len then
        count := max_len
      else count := p_cur^;

      sum := 0;

      for Y := 0  to count do
        Inc(sum, p_cur[Y]);

      median := median + sum div count;
    end;

    Result := median;
  end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
