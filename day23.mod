MODULE Day23;
(*
  Day #23 : even on a fast PC, interpretation of the input program is too slow...
  So, reverse engineering of the input code was necessary, but to which level ?

  The answer to part #1 can be given by analyzing the code : double loop starting
  from d:=2 to 93 (excluded) and e:=2 to 93 (excluded), thus 91*91=8281.
  In order to provide some code, I have translated the input to Modula-2 as if
  it were an automatic translation (well, Modula-2 does not have GOTOs)...

  And the answer to part #2 needs to determine how many numbers from 109300 to 126300
  by step of 17 are not prime...
  So a simple algorithm is provided for this task.
*)

PROCEDURE part1() : CARDINAL;
VAR a,b,c,d,e,f,g,h : INTEGER;
    mulCount : CARDINAL;
BEGIN
  mulCount := 0;
  a:=0; b:=0; c:=0; d:=0; e:=0; f:=0; g:=0; h:=0;

(* line 01: set b 93        *)   b := 93;
(* line 02: set c b         *)   c := b;
(* line 03: jnz a 2         *)   IF a<>0 THEN (* ok, skip these since a=0 *)
(* line 04: jnz 1 5         *)
(* line 05: mul b 100       *)
(* line 06: sub b -100000   *)
(* line 07: set c b         *)
(* line 08: sub c -17000    *)
                                 END;
(* line 09: set f 1         *)   f := 1;
(* line 10: set d 2         *)   d := 2;
                                 REPEAT
(* line 11: set e 2         *)     e := 2;
                                   REPEAT
(* line 12: set g d         *)       g := d;
(* line 13: mul g e         *)       g := g * e;               INC(mulCount);
(* line 14: sub g b         *)       g := g - b;
(* line 15: jnz g 2         *)       IF g = 0 THEN
(* line 16: set f 0         *)         f := 0;
                                     END;
(* line 17: sub e -1        *)       e := e + 1;
(* line 18: set g e         *)       g := e;
(* line 19: sub g b         *)       g := g - b;
(* line 20: jnz g -8        *)     UNTIL g = 0;
(* line 21: sub d -1        *)     d := d + 1;
(* line 22: set g d         *)     g := d;
(* line 23: sub g b         *)     g := g - b;
(* line 24: jnz g -13       *)   UNTIL g = 0;
(* line 25: jnz f 2         *)   IF f = 0 THEN
(* line 26: sub h -1        *)     h := h + 1;
                                 END;
(* line 27: set g b         *)   g := b;
(* line 28: sub g c         *)   g := g - c;
(* line 29: jnz g 2         *)   IF g = 0 THEN (* ok we know that b=c=93 *)
(* line 30: jnz 1 3         *)     RETURN mulCount;
                                 END;
(* line 31: sub b -17       *)
(* line 32: jnz 1 -23       *)

END part1;

PROCEDURE prime(b : LONGINT) : BOOLEAN;
VAR d : LONGINT;
BEGIN
  IF b MOD 2L = 0L THEN RETURN FALSE END;
  d := 3L;
  WHILE d*d <= b DO
    IF b MOD d = 0L THEN RETURN FALSE END;
    d := d + 2L;
  END;
  RETURN TRUE;
END prime;

PROCEDURE part2() : CARDINAL;
VAR h : CARDINAL;
    b : LONGINT;
BEGIN
  h := 0;
  b := 109300L;
  WHILE b<=126300L DO
    IF NOT prime(b) THEN INC(h) END;
    b := b + 17L;
  END;
  RETURN h
END part2;

BEGIN
  WRITELN(part1(), ' MUL instructions.');
  WRITELN('h = ',part2());
END Day23.

