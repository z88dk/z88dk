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
Z88DK August 17, 2026
zsdcc 4.6.0 #16639 / new c library / quicksort
1041 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20          70266     0.0176 sec
sort-ord-20          44330     0.0111 sec
sort-rev-20          62510     0.0156 sec
sort-equ-20          44330     0.0111 sec

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
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / classic c library / quicksort
1854 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20          51721     0.0129 sec
sort-ord-20          39379     0.0098 sec
sort-rev-20          46416     0.0116 sec
sort-equ-20         121709     0.0304 sec

3b.
Z88DK August 18, 2026
80cc / classic c library / quicksort
1933 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20          50233     0.0126 sec
sort-ord-20          38248     0.0096 sec
sort-rev-20          45159     0.0113 sec
sort-equ-20         117722     0.0294 sec

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
SDCC 4.6.0 #16608 Linux
964 bytes less page zero

               cycle count    time @ 4MHz

sort-ran-20         109535     0.0274 sec
sort-ord-20          95078     0.0238 sec
sort-rev-20         111590     0.0279 sec
sort-equ-20         180386     0.0451 sec

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
Z88DK August 17, 2026
zsdcc 4.6.0 #16639 / new c library / quicksort

               cycle count    time @ 4MHz

sort-ran-5000     81681998    20.4205 sec
sort-ord-5000     35928280     8.9821 sec
sort-rev-5000     54956814    13.7392 sec
sort-equ-5000     35928280     8.9821 sec

2.
Z88DK March 25, 2017
sccz80 / new c library / quicksort

               cycle count    time @ 4MHz

sort-ran-5000     56833460    14.2084 sec
sort-ord-5000     58340767    14.5852 sec
sort-rev-5000     44873477    11.2184 sec
sort-equ-5000     40106741    10.0267 sec

3.
Z88DK August 16, 2026
zsdcc 4.6.0 #16639 / classic c library / quicksort

               cycle count    time @ 4MHz

sort-ran-5000     40235859    10.0590 sec
sort-ord-5000     30382407     7.5956 sec
sort-rev-5000     32248314     8.0621 sec
sort-equ-5000   6716015259    1679.0038 sec

3b.
Z88DK August 17, 2026
80cc / classic c library / quicksort

               cycle count    time @ 4MHz

sort-ran-5000     38866533     9.7166 sec
sort-ord-5000     29294145     7.3235 sec
sort-rev-5000     31126158     7.7815 sec
sort-equ-5000   6453567759    1613.3919 sec

4.
Z88DK March 25, 2017
sccz80 / classic c library/ shellsort

               cycle count    time @ 4MHz

sort-ran-5000     80957310    20.2393 sec
sort-ord-5000     41381930    10.3455 sec
sort-rev-5000     63068198    15.7670 sec
sort-equ-5000     41381930    10.3455 sec

5.
SDCC 4.6.0 #16608 Linux

               cycle count    time @ 4MHz

sort-ran-5000     75265433    18.8164 sec
sort-ord-5000     59249752    14.8124 sec
sort-rev-5000     65223791    16.3059 sec
sort-equ-5000         did not finish*

qsort is not present in library, instead one is supplied from the internet.
Naive implementation stumbles on equal items edge case.

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
