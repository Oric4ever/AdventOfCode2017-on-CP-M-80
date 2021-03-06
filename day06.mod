MODULE Day06;
(*
  Day #6: this one is interesting...
  On PC I was using a large array to memorize past configurations, 
  in order to first find the number of configurations before cycling starts,
  and then periodicity of the redistribution process.
  Here I don't have such a big memory, so I first determined the
  periodicity of the cycle after the initial redistributions, and
  then the number of redistributions in a cycle... 
  ... all this with only 3 configurations.
*)
IMPORT Texts;
EXCEPTION FileNotFound;
CONST N=16;
TYPE Block = ARRAY [1..N] OF CARDINAL;
VAR initial,block,save : Block;
    i,n,cycle : CARDINAL;
    input : Texts.TEXT;
    same : BOOLEAN;

PROCEDURE Redistribute(VAR block : Block; times : CARDINAL);
VAR n,index,i,count : CARDINAL;
BEGIN
  FOR n:=1 TO times DO
    index := 1;
    FOR i:=2 TO N DO
      IF block[i]>block[index] THEN index:=i END
    END;
    count := block[index];
    block[index] := 0;
    FOR i:=index+1 TO index+count DO
      IF i<=N THEN INC(block[i]) ELSE INC(block[i-N]) END
    END
  END
END Redistribute;

PROCEDURE Equal(VAR block1,block2 : Block) : BOOLEAN;
VAR i : CARDINAL;
BEGIN
  FOR i:=1 TO N DO
    IF block1[i] # block2[i] THEN RETURN FALSE END;
  END;
  RETURN TRUE;
END Equal;

BEGIN
  IF NOT Texts.OpenText(input,"DAY06.IN") THEN RAISE FileNotFound END;
  FOR i:=1 TO N DO Texts.ReadCard(input,initial[i]) END;
  Texts.CloseText(input);

  block:=initial;
  Redistribute(block,10000);
  save:=block;
  cycle:=0;
  REPEAT
    INC(cycle);
    Redistribute(block,1);
  UNTIL Equal(block,save);
  WRITELN(cycle,' redistributions in the cycle');

  block:=initial;
  Redistribute(block,cycle);
  save:=initial;
  n:=0;
  WHILE NOT Equal(block,save) DO
    Redistribute(block,1);
    Redistribute(save,1);
    INC(n);
  END;
  WRITELN(n+cycle,' redistributions before cycling');
END Day06.
