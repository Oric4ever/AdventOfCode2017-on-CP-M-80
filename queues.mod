IMPLEMENTATION MODULE Queues;
FROM STORAGE IMPORT ALLOCATE;
FROM SYSTEM IMPORT ADDRESS;
IMPORT Processes;

TYPE Queue = POINTER TO
       RECORD
         start, end, putPtr, getPtr, last : ADDRESS;
         dataReady : Processes.SIGNAL;
         elemSize, nbSent : CARDINAL;
       END;

PROCEDURE Enqueue(queue : Queue; VAR elem : ARRAY OF WORD);
VAR i : CARDINAL;
BEGIN
  WITH queue^ DO
    last := putPtr;
    FOR i:=0 TO elemSize-1 DO putPtr^ := elem[i]; INC(putPtr,2) END;
    IF putPtr = end THEN putPtr := start END;
    IF putPtr = getPtr THEN RAISE QueueOverflow END;
    INC(nbSent);
    Processes.SEND(dataReady);
  END;
END Enqueue;

PROCEDURE Dequeue(queue : Queue; VAR elem : ARRAY OF WORD);
VAR i : CARDINAL;
BEGIN
  WITH queue^ DO
    IF putPtr = getPtr THEN Processes.WAIT(dataReady) END;
    FOR i:=0 TO elemSize-1 DO elem[i]:=getPtr^ ; INC(getPtr,2) END;
    IF getPtr = end THEN getPtr := start END;
  END;
END Dequeue;

PROCEDURE Last(queue : Queue; VAR elem : ARRAY OF WORD);
VAR i : CARDINAL;
    lastPtr : ADDRESS;
BEGIN
  WITH queue^ DO
    IF getPtr = putPtr THEN RAISE EmptyQueue END;
    lastPtr := last;
    FOR i:=0 TO elemSize-1 DO elem[i]:=lastPtr^ ; INC(lastPtr,2) END
  END
END Last;

PROCEDURE Count(queue : Queue) : CARDINAL;
BEGIN
  RETURN queue^.nbSent;
END Count;

PROCEDURE New(queueLength, nbWords : CARDINAL) : Queue;
VAR queue : Queue;
    totalSize : CARDINAL;
BEGIN
  NEW(queue);
  WITH queue^ DO
    elemSize := nbWords;
    totalSize := queueLength*nbWords*2;
    ALLOCATE(start,totalSize);
    end := start + totalSize;
    putPtr := start;
    getPtr := start;
    nbSent := 0;
    Processes.Init(dataReady);
  END;
  RETURN queue;
END New;

END Queues.
