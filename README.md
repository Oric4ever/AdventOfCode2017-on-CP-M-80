# AdventOfCode2017-on-CP-M-80

Here are my solutions for the Advent of Code 2017 ( http://adventofcode.com/2017 ) on CP/M 80...

I wanted to prove that the challenges can be done on a Z80 computer with 64 KB of RAM, which can be sometimes 1000000 slower than a modern PC (eg with double precision calculations)... I had previously done the Adventofcode 2017 on a modern PC and realized that most of the time, I naturally select the simplest algorithms (as long as brute force is able to solve the problems in a reasonnable time), so it looks like power of the modern computers makes me "lazy"... On the other hand, working with much less cpu power and memory space often requires to either found mathematical properties that reduce the problems, or to highly optimize the implementations for efficiency...

I tried to do all the challenges with Turbo Modula-2 for CP/M 80, an excellent development environment written by Martin Odersky, and often the language really shines (IHMO the solution to Day 23 is really elegant, the coroutines of Modula-2 and a small implementation of communication queues fit perfectly !). Some challenges were painful though, often when large integers computations were required : Turbo Modula-2 for CP/M 80 has a 16-bit INTEGER type (and CARDINAL type too), and it can also deal with 32-bits integers with its LONGINT type, but it has no 64-bits type, so for some challenges I had to use the LONGREAL floating point type (the mantissa is not 64-bits long but it was enough).

A word on the old computer targeted by these challenges : the Oric Phoenix is sort of a "chimera" (a computer that went to the prototyping stage but was never commercialized). It is powered by a 6.144 Mhz HD64180 micro-controller, which integrates a Z80-compatible core and some peripherals (Timers, UARTs...). It runs CP/M 2.2, and it has two floppy drives: for some challenges (like the dancers) it is really fun (and slow) to read the Day's input from a file on floppy... I might point to some videos for some of the challenges, showing this CP/M computer in action...

From my point of view, here are the most interesting challenges :
- day #6 : determining the periodicity of the cycle and the start of the cycle without memorizing all the previous configurations...
- day #13 : using the Chinese Remainders Theorem to greatly reduce the number of computations
- day #16 : finding cycles to reduce the number of computations
- day #18 : Modula-2 shines here with its integrated coroutines!

Status : nearly finished, I have to :
- fetch back Day #16 from my CP/M floppy disk, 
- optimise day #13 with Chinese Remainders Theorem
- do day #21
- measure execution time of all programs
