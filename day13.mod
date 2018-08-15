MODULE Day13;
IMPORT Texts;

CONST N = 43;
      Size = 100;

VAR srange, period, pos : ARRAY [0..Size-1] OF CARDINAL;
(*
    up : ARRAY [0..Size-1] OF BOOLEAN;

PROCEDURE Reset;
VAR i : CARDINAL;
BEGIN
  FOR i:=0 TO Size-1 DO
    pos[i] := 0;
    up[i] := FALSE;
  END
END Reset;

PROCEDURE MoveScan;
VAR i : CARDINAL;
EXCEPTION ScanError;
BEGIN
  FOR i:=0 TO Size-1 DO
    IF srange[i] <> 0 THEN
      IF up[i] AND (pos[i]<>0) THEN DEC(pos[i])
      ELSIF NOT up[i] AND (pos[i] < srange[i] - 1) THEN INC(pos[i])
      ELSE RAISE ScanError;
      END;

      IF pos[i]=0 THEN up[i]:=FALSE END;
      IF pos[i] = srange[i] - 1 THEN up[i]:=TRUE END;
    END
  END
END MoveScan;
*)

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
  IF NOT Texts.OpenText(input,"DAY13.TXT") THEN RAISE FileNotFound END;
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
