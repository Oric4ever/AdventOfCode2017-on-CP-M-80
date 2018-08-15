MODULE Day13;
(*
   Day #13: currently way too long...
   I have to rewrite this using the Chinese Remainder Theorem...
*)
IMPORT Texts;

CONST N = 43;
      Size = 100;

VAR srange, period, pos : ARRAY [0..Size-1] OF CARDINAL;

PROCEDURE IsCaught(delay : LONGINT) : BOOLEAN;
VAR depth : CARDINAL;
    time : LONGINT;
BEGIN
  time := delay;
  FOR depth:=0 TO Size-1 DO
    IF (period[depth]<>0) AND (time MOD LONG(period[depth]) = 0L) THEN RETURN TRUE END;
    time := time + 1L;
  END;
  RETURN FALSE
END IsCaught;

VAR input : Texts.TEXT;
    i, depth, severity, time : CARDINAL;
    delay : LONGINT;
EXCEPTION FileNotFound;
BEGIN
  IF NOT Texts.OpenText(input,"DAY13.IN") THEN RAISE FileNotFound END;
  FOR i:=1 TO N DO
    Texts.ReadCard(input,depth);
    Texts.ReadCard(input,srange[depth]);
    period[depth] := 2 * (srange[depth] - 1);
  END;

  severity := 0;
  time := 0;
  FOR depth:=0 TO Size DO
    IF (period[depth] <> 0) AND (time MOD period[depth] = 0) THEN
      INC(severity, depth * srange[depth])
    END;
    INC(time);
  END;
  WRITELN('Severity : ',severity);

  delay := 2L;
  LOOP
    IF NOT IsCaught(delay) THEN EXIT END;
    delay := delay + 4L;
  END;
  WRITELN('Not caught with delay ',delay);
END Day13.
