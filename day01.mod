MODULE Day1;
(*
  First day, simple array access with modulo indexes, nothing very interesting here...
  Thus wrote an additional Input module to hide the input read...
*)
FROM Input IMPORT ReadCharInput;

VAR data : ARRAY [0..9999] OF CHAR;
    size: CARDINAL;
    i, sum1, sum2 : CARDINAL;

BEGIN
  ReadCharInput("DAY01.IN",data,size);
  FOR i:=0 TO size-1 DO
    IF data[i]=data[(i+1) MOD size] THEN
      sum1 := sum1 + ORD(data[i]) - 30H;
    END;
    IF data[i]=data[(i + size DIV 2) MOD size] THEN
      sum2 := sum2 + ORD(data[i]) - 30H;
    END;
  END;

  WRITELN("sum1 = ", sum1);
  WRITELN("sum2 = ", sum2);
END Day1.

