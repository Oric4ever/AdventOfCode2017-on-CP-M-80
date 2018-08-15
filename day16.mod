MODULE Day16;
FROM Texts IMPORT TEXT, OpenText, CloseText, ReadChar, EOLN, ReadAgain;
CONST N = 16;
      start = 'abcdefghijklmnop';
TYPE Config = ARRAY [0..N-1] OF CHAR;
VAR current : Config;
    cycle,danceNum : LONGINT;
    input : TEXT;

PROCEDURE Spin(n : CARDINAL);
VAR old : Config;
    i : CARDINAL;
BEGIN
  old := current;
  FOR i:=0 TO n-1 DO current[i] := old[N-n+i] END;
  FOR i:=0 TO N-n-1 DO current[i+n] := old[i] END;
END Spin;

PROCEDURE Exchange(a,b : CARDINAL);
VAR tmp : CHAR;
BEGIN
  tmp := current[a]; current[a] := current[b]; current[b] := tmp;
END Exchange;

PROCEDURE Partner(a,b : CHAR);
VAR i : CARDINAL;
BEGIN
  FOR i:=0 TO N-1 DO
    IF    current[i]=a THEN current[i]:=b
    ELSIF current[i]=b THEN current[i]:=a
    END
  END;
END Partner;

PROCEDURE ReadNum(input:TEXT; VAR n:CARDINAL);
VAR c : CHAR;
BEGIN
  n := 0;
  ReadChar(input,c);
  WHILE (c>='0') AND (c<='9') DO
    n := 10*n + ORD(c) - 48;
    ReadChar(input,c);
  END;
  ReadAgain(input);
END ReadNum;

PROCEDURE Dance(filename : ARRAY OF CHAR);
VAR a,b,c,num1,num2,tmp : CHAR;
    i,j,n : CARDINAL;
    old : Config;
    msg : ARRAY[0..3] OF CHAR;
EXCEPTION FileNotFound,BadCommand;
BEGIN
  IF NOT OpenText(input,filename) THEN RAISE FileNotFound,filename END;
  WHILE NOT EOLN(input) DO
    ReadChar(input,c);
    CASE c OF
    | 'x' : ReadNum(input,i); ReadChar(input,tmp); ReadNum(input,j);
            tmp := current[i] ; current[i] := current[j]; current[j] := tmp;
    | 'p' : ReadChar(input,a); ReadChar(input,tmp); ReadChar(input,b);
            FOR i:=0 TO N-1 DO
              IF    current[i]=a THEN current[i]:=b
              ELSIF current[i]=b THEN current[i]:=a
              END
            END;
    | 's' : ReadNum(input,n);
            old := current;
            FOR i:=0 TO n-1 DO current[i] := old[N-n+i] END;
            FOR i:=0 TO N-n-1 DO current[i+n] := old[i] END;
    | ELSE msg[0]:=c; msg[1]:=0C; RAISE BadCommand,msg
    END;
    ReadChar(input,tmp);
  END;
  CloseText(input);
END Dance;

BEGIN
  current  := start;
  danceNum := 0L;
  REPEAT
    danceNum := danceNum + 1L;
    WRITE('Dance #',danceNum,' in progress...');
    Dance("DAY16.TXT");
    WRITELN(' => ',current);
  UNTIL current=start;
  WRITELN('...');
  WRITELN('...');
  WRITELN('...');
  danceNum  := (1000000000L DIV danceNum) * danceNum;
  WHILE danceNum < 1000000000L DO
    danceNum := danceNum + 1L;
    WRITE('Dance #',danceNum,' in progress...');
    Dance("DAY16.TXT");
    WRITELN(' => ',current);
  END;
END Day16.