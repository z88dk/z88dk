SIEVE OF ERATOSTHENES (PRIME NUMBERS)
=====================================

Sieve.c finds all the prime numbers in [2,7999].  The algorithm
is known as the Sieve of Eratosthenes.

https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes

This is a popular benchmark for small machine compilers because
just about every compiler is able to compile it.

As a benchmarking tool it's mainly measuring loop overhead as
the loops tend to be very tight.

The base source code used for benchmarking is in this directory.

This is modified as little as possible to be compilable by the
compilers under test and that modified source code is present in
subdirectories.

The performance metric is time to complete in seconds.

/*
 * COMMAND LINE DEFINES
 * 
 * -DSIZE=N
 * Investigate numbers 2..N-1 for primes.
 *
 * -DSTATIC
 * Use static variables instead of locals.
 *
 * -DPRINTF
 * Enable printf.
 *
 * -DTIMER
 * Insert asm labels into source code at timing points.
 *
 */

STATIC can be optionally defined in order to increase the compiler's
performance.

TIMER is defined for Z88DK compiles so that assembly labels are inserted
into the code at time begin and time stop points.

All compiles are first checked for correctness by running the program
with PRINTF defined.  After correctness is verified, time should be
measured with PRINTF undefined so that execution time of printf is not
measured.

In total 1007 primes should be found by the program and some of the listed
number can be checked against the first 10000 primes for verification:
https://primes.utm.edu/lists/small/10000.txt

For a timed run, the program is compiled and simulated by TICKS.  TICKS
must be given a start address to start timing and a stop address to stop
timing.  In Z88DK compiles these show up in the map file.  Other compilers'
output may have to be disassembled to locate the correct address range.

The output of TICKS is a cycle count.  To convert to time in seconds:

Execution_Time = CYCLE_COUNT / FCPU
where FCPU = clock frequency of Z80 in Hz.


RESULTS
=======

1.
Z88DK April 20, 2020
zsdcc #11566 / new c library
8315 bytes less page zero

cycle count  = 3665494
time @ 4MHZ  = 3665494 / 4*10^6 = 0.9163 sec

2.
HITECH C MSDOS V780pl2
8472 bytes exact

cycle count  = 3885436
time @ 4MHz  = 3885436 / 4x10^6 = 0.9713 seconds

3.
IAR Z80 V4.06A
8772 bytes less small amount

cycle count  = 3714152
time @ 4MHz  = 3714152 / 4*10^6 = 0.9285 sec

4.
Z88DK January 5, 2022
zsdcc #12555 / classic c library
9177 bytes less page zero

cycle count  = 4110873
time @ 4MHZ  = 4110873 / 4*10^6 = 1.0277 sec

5.
HITECH C CPM V309-15
10297 bytes exact

cycle count  = 7916099
time @ 4MHz  = 7916099 / 4*10^6 = 1.979 sec

6.
SDCC 4.2.0 Linux
8278 bytes less page zero

cycle count  = 4219481
time @ 4MHz  = 4219481 / 4*10^6 = 1.0548 sec

7.
Z88DK April 20, 2020
sccz80 / new c library
8362 bytes less page zero

cycle count  = 4957733
time @ 4MHz  = 4957733 / 4*10^6 = 1.2394 sec

7.
Z88DK January 5, 2022
sccz80 / classic c library
9185 bytes less page zero

cycle count  = 4769143
time @ 4MHz  = 4769143 / 4*10^6 = 1.1923 sec

8.
Z88DK January 5, 2022
sccz80 / classic c library / 8085
9278 bytes less page zero

cycle count  = 5129695
time @ 4MHz  = 5129695 / 4*10^6 = 1.2824 sec

