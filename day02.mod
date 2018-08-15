MODULE Day2;
(*
   Day #2, nothing special here...
*)
IMPORT Texts;

CONST size = 16;
VAR calc: ARRAY [1..16] OF ARRAY [1..16] OF CARDINAL;
    row,col,sum1,sum2,min,max,a,b,col2 : CARDINAL;
    file : Texts.TEXT;
EXCEPTION FileNotFound;

BEGIN
  IF NOT Texts.OpenText(file,"DAY02.IN") THEN RAISE FileNotFound END;
  FOR row:=1 TO size DO
    FOR col:=1 TO size DO
      Texts.ReadCard(file,calc[row][col]);
      WRITELN(calc[row][col]);
    END;
  END;
  Texts.CloseText(file);

  sum1 := 0; sum2 := 0;
  FOR row:=1 TO size DO
    min := 65535;
    max := 0;
    FOR col:=1 TO size DO
      a := calc[row][col];
      IF a<min THEN min := a END;
      IF a>max THEN max := a END;
      FOR col2:=col+1 TO size DO
        b := calc[row][col2];
        IF (a>b) AND ((a MOD b) = 0) THEN sum2 := sum2 + a DIV b END;
        IF (b>a) AND ((b MOD a) = 0) THEN sum2 := sum2 + b DIV a END;
      END
    END;
    sum1 := sum1 + max - min;
  END;

  WRITELN("Sum1 = ",sum1);
  WRITELN("Sum2 = ",sum2);
END Day2.
