MODULE Day20;
(*
  Day #20: this implementation does the simulation,
  and stops when the particles' coordinates exit the INTEGER range.
  (hopefully, no collision occurs outside this range).

  Don't forget to compile with Overflow detection...
*)
IMPORT Texts,Strings,Convert;
FROM Strings IMPORT String;
FROM SYSTEM IMPORT OVERFLOW;
CONST N = 1000;
      INFINITE = 32767;
TYPE Particle =
       RECORD
         px,py,pz : INTEGER;
         vx,vy,vz : INTEGER;
         ax,ay,az : INTEGER;
         dist     : INTEGER;
         alive, inRange : BOOLEAN;
       END;
VAR particles : ARRAY [1..N] OF Particle;
    remaining, nbInRange : CARDINAL;

PROCEDURE moveAll;
VAR i : CARDINAL;
  PROCEDURE moveParticle;
  BEGIN
    WITH particles[i] DO
      vx:=vx+ax; vy:=vy+ay; vz:=vz+az;
      px:=px+vx; py:=py+vy; pz:=pz+vz;
      dist:=ABS(px)+ABS(py)+ABS(pz);
    END
  EXCEPTION OVERFLOW:
    particles[i].inRange := FALSE;
    DEC(nbInRange);
  END moveParticle;
BEGIN
  FOR i:=1 TO N DO
    IF particles[i].alive AND particles[i].inRange THEN moveParticle END
  END;
END moveAll;

PROCEDURE findCollisions(VAR nbRemoved : CARDINAL);
VAR j, i, start, limit : CARDINAL;
    x, y, z : INTEGER;
    collision : BOOLEAN;
BEGIN
  nbRemoved := 0;
  FOR i:=1 TO N DO
    IF particles[i].alive AND particles[i].inRange THEN
      collision := FALSE;
      x := particles[i].px;  y := particles[i].py;  z := particles[i].pz;
      FOR j:=i+1 TO N DO
        WITH particles[j] DO
          IF alive AND inRange AND (px = x) AND (py = y) AND (pz = z) THEN
            collision := TRUE;  alive := FALSE;  INC(nbRemoved)
          END;
        END;
      END;
      IF collision THEN
        WITH particles[i] DO alive := FALSE; INC(nbRemoved) END
      END;
    END;
  END;
END findCollisions;


PROCEDURE ReadCoords(str : String; VAR x, y, z : INTEGER);
VAR index, length : CARDINAL;
    substring : String;
EXCEPTION BadFormat;
BEGIN
  length := Strings.Length(str); DEC(length,3);
  Strings.Copy(str,3,length,substring);
  str := substring;
  index := Strings.Pos(",",str);
  Strings.Copy(str,0,index,substring);
  IF NOT Convert.StrToInt(substring,x) THEN RAISE BadFormat END;
  DEC(length, index+1);
  Strings.Copy(str,index+1,length,substring);
  str := substring;
  index := Strings.Pos(",",str);
  Strings.Copy(str,0,index,substring);
  IF NOT Convert.StrToInt(substring,y) THEN RAISE BadFormat END;
  DEC(length, index+1);
  Strings.Copy(str,index+1,length,substring);
  str := substring;
  index := Strings.Pos('>',str);
  Strings.Copy(str,0,index,substring);
  IF NOT Convert.StrToInt(substring,z) THEN RAISE BadFormat END;
END ReadCoords;


VAR i, tick, nbRemoved, indx : CARDINAL;
    input : Texts.TEXT;
    coord, speed, accel, str : Strings.String;
EXCEPTION FileNotFound;
BEGIN
  IF NOT Texts.OpenText(input,"DAY20.IN") THEN RAISE FileNotFound END;
  FOR i:=1 TO N DO
    WITH particles[i] DO
      Texts.ReadString(input,coord); ReadCoords(coord,px,py,pz);
      Texts.ReadString(input,speed); ReadCoords(speed,vx,vy,vz);
      Texts.ReadLine(input,accel);   ReadCoords(accel,ax,ay,az);
      dist := ABS(px) + ABS(py) + ABS(pz);
      alive := TRUE; inRange := TRUE;
    END
  END;
  Texts.CloseText(input);

  remaining := N; nbInRange := N; tick := 0;
  WHILE nbInRange > 1 DO
    findCollisions(nbRemoved);
    moveAll;
    DEC(remaining, nbRemoved); DEC(nbInRange, nbRemoved);
    WRITELN('Tick ',tick,': ',remaining,' particles remaining...');
    INC(tick);
  END
END Day20.

