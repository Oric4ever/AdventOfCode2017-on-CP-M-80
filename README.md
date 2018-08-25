# AdventOfCode2017-on-CP-M-80

Here are my solutions for the Advent of Code 2017 ( http://adventofcode.com/2017 ) on CP/M 80...

I wanted to prove that the challenges can be done on a Z80 computer with 64 KB of RAM, which can be sometimes 1000000 slower than a modern PC (eg with double precision calculations)... I had previously done the Adventofcode 2017 on a modern PC and realized that most of the time, I naturally select the simplest algorithms (as long as brute force is able to solve the problems in a reasonable time), so it looks like power of the modern computers makes me "lazy"... On the other hand, working with much less cpu power and memory space often requires to either found mathematical properties that reduce the problems, or to highly optimize the implementations for efficiency...

I wanted to do all the challenges with Turbo Modula-2 for CP/M 80, an excellent development environment written by Martin Odersky, and often the language really shines (IHMO the solution to Day 23 is really elegant, the coroutines of Modula-2 and a small implementation of communication queues fit perfectly !). Some challenges were painful though, often when large integers computations were required : Turbo Modula-2 for CP/M 80 has a 16-bit INTEGER type (and CARDINAL type too), and it can also deal with 32-bits integers with its LONGINT type, but it has no 64-bits type, so for some challenges I had to use the LONGREAL floating point type (the mantissa is not 64-bits long but it was enough).

For all the challenges you will find a typical puzzle input (dayNN.in, except when no puzzle input was provided, or when the puzzle input was so simple it was inserted as a constant in the code)... Of course, this is my account's personalized input on the Adventofcode site, so if you want to check the result is correct, replace these .in files by your own account's puzzle inputs.

A word on the old computer targeted by these challenges : the Oric Phoenix is sort of a "chimera" (a computer that went to the prototyping stage but was never commercialized). It is powered by a 6.144 Mhz HD64180 micro-controller, which integrates a Z80-compatible core and some peripherals (Timers, UARTs...). It runs CP/M 2.2, and it has two floppy drives: for some challenges (like the dancers) it is really fun (and slow) to read the Day's input from a file on floppy... I might point to some videos for some of the challenges, showing this CP/M computer in action... To be honest, for most of the development I used Udo Munk's Z80-SIM emulator with "unlimited cpu speed", and ran the final program on the Oric Phoenix afterwards (it seems that once you get used to speed, it's difficult to go back). This use of Z80-SIM revealed a bad surprise on day #19: I was happy that the 40 KB input map could be loaded in memory and when I tried it on my real system the memory wasn't large enough... Actually, the TPA (Transient Program Area) is 2KB smaller on my system than the one in Z80-SIM. So, to get an idea of the space available for code plus data on my system, I ran (as a .COM program) the following minimal program :
MODULE FreeMem;
FROM STORAGE IMPORT FREEMEM;
BEGIN
  WRITELN(FREEMEM())
END FreeMem.
... and the output is 42081 bytes. Hopefully, for Day #19, I was able to run the program on my system by removing an unnecessary import of the Strings module... Three days out of the 25 days require to link the program in a .COM program in order to use all the available memory : days #7, #19 and #22.

Anyway, this is starting to be a long description, so as a conclusion, below is a list of the most interesting challenges (from my point of view) :
- day #6 : determining the periodicity of the cycle and the start of the cycle without memorizing all the previous configurations...
- day #13 : requires a lot of optimization
- day #16 : finding cycles to reduce the number of computations
- day #18 : Modula-2 shines here with its integrated coroutines!
- day #21 : had to calculate a lot of indirection tables in order to reduce both the ram consumption and execution time

Status : all days done, but I have to :
- optimise day #13 with Chinese Remainders Theorem
- if possible, further optimize days #5, #15, #16, #17, #20, #22, #24, #25 as they require more than 20 minutes of execution time on my system.
- link one or two videos to show the Oric Phoenix in action..
