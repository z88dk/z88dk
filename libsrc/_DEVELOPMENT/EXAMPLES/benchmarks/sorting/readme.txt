SORTING
=======

This benchmark tests the performance of the compiler library's qsort function.

Some of the C compilers under test do not supply a qsort() function so for those
a common & small implementation has been sourced from the internet.  Unfortunately
the kind of subroutine that one might commonly source from the internet quite often
has poor edge case performance.  However we stick with that because that is likely
what most users will use after realizing a compiler's library implementation is
incomplete.

To test the quality of the implementation, common cases and edge cases are tested:

1. Items are initially in random order.
2. Items are already sorted.
3. Items are in reverse order.
4. Items are all equal.

For each test case above, two scenarios are considered: sorting a small number of
items (20) and sorting a large number of items (5000).


RESULTS - 20 ITEMS
==================

1.
Z88DK March 25, 2017
zsdcc #9852 / new c library / quicksort
1303 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20          68554     0.0171 sec
sort-ord-20          26210     0.0066 sec
sort-rev-20          38369     0.0096 sec
sort-equ-20          37122     0.0093 sec

2.
Z88DK March 25, 2017
sccz80 / new c library / quicksort
1403 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20          70502     0.0176 sec
sort-ord-20          28531     0.0071 sec
sort-rev-20          41986     0.0105 sec
sort-equ-20          41701     0.0104 sec

3.
Z88DK March 25, 2017
zsdcc #9852 / classic c library / shellsort
995 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20          77922     0.0195 sec
sort-ord-20          50242     0.0126 sec
sort-rev-20          70672     0.0177 sec
sort-equ-20          50242     0.0126 sec

4.
Z88DK March 25, 2017
sccz80 / classic c library / shellsort
1029 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20          81544     0.0204 sec
sort-ord-20          53944     0.0135 sec
sort-rev-20          75472     0.0189 sec
sort-equ-20          53944     0.0135 sec

5.
SDCC 3.6.5 #9852 (MINGW64)
1080 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20         113965     0.0285 sec
sort-ord-20          99399     0.0248 sec
sort-rev-20         116849     0.0292 sec
sort-equ-20         184267     0.0461 sec

6.
HITECH C MSDOS V750
2479 bytes exact

               cycle count    time @ 4MHz

sort-ran-20         230384     0.0576 sec
sort-ord-20         134515     0.0336 sec
sort-rev-20         163275     0.0408 sec
sort-equ-20         206389     0.0516 sec

7.
IAR Z80 V4.06A
1768 bytes less small amount

               cycle count    time @ 4MHz

sort-ran-20         277760     0.0694 sec
sort-ord-20         170327     0.0426 sec
sort-rev-20         241931     0.0605 sec
sort-equ-20         389227     0.0973 sec

DQ.
HITECH C CPM V309
Unable to compile


RESULTS - 5000 ITEMS
====================

1.
Z88DK March 25, 2017
zsdcc #9852 / new c library / quicksort

               cycle count    time @ 4MHz

sort-ran-5000     59078884    14.7697 sec
sort-ord-5000     50466524    12.6166 sec
sort-rev-5000     40192485    10.0481 sec
sort-equ-5000     32362669     8.0907 sec

2.
Z88DK March 25, 2017
sccz80 / new c library / quicksort

               cycle count    time @ 4MHz

sort-ran-5000     56833460    14.2084 sec
sort-ord-5000     58340767    14.5852 sec
sort-rev-5000     44873477    11.2184 sec
sort-equ-5000     40106741    10.0267 sec

3.
Z88DK March 25, 2017
zsdcc #9852 / classic c library / shellsort

               cycle count    time @ 4MHz

sort-ran-5000     85903658    21.4759 sec
sort-ord-5000     38026708     9.5067 sec
sort-rev-5000     58261603    14.5654 sec
sort-equ-5000     38026708     9.5067 sec

4.
Z88DK March 25, 2017
sccz80 / classic c library/ shellsort

               cycle count    time @ 4MHz

sort-ran-5000     80957310    20.2393 sec
sort-ord-5000     41381930    10.3455 sec
sort-rev-5000     63068198    15.7670 sec
sort-equ-5000     41381930    10.3455 sec

5.
SDCC 3.6.5 #9852 (MINGW64)

               cycle count    time @ 4MHz

sort-ran-5000     77526792    19.3817 sec
sort-ord-5000     61119685    15.2799 sec
sort-rev-5000     67382381    16.8456 sec
sort-equ-5000         did not finish*

qsort is not present in library, instead one is supplied from the internet.
* If this not a bug, will have to move down a place.

6.
HITECH C MSDOS V750

               cycle count    time @ 4MHz

sort-ran-5000    126858892    31.7147 sec
sort-ord-5000     72285966    18.0715 sec
sort-rev-5000     77909169    19.4773 sec
sort-equ-5000    136825609    34.2064 sec

7.
IAR Z80 V4.06A

               cycle count    time @ 4MHz

sort-ran-5000    228101043    57.0253 sec
sort-ord-5000     94750857    23.6877 sec
sort-rev-5000    124100937    31.0252 sec
sort-equ-5000  13597091697    56 min 39 sec

IAR contains a naive implementation of quicksort
that stumbles on the equal items edge case.

DQ.
HITECH C CPM V309
Unable to compile
