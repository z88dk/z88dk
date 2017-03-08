fannkuch-redux description
--------------------------


Background
----------

The fannkuch benchmark is defined by programs in Performing Lisp Analysis of the FANNKUCH Benchmark, Kenneth R. Anderson and Duane Rettig. FANNKUCH is an abbreviation for the German word Pfannkuchen, or pancakes, in analogy to flipping pancakes. The conjecture is that the maximum count is approximated by n*log(n) when n goes to infinity.


How to implement
----------------

We ask that contributed programs not only give the correct result, but also use the same algorithm to calculate that result.

Each program should:

    Take a permutation of {1,...,n}, for example: {4,2,1,5,3}.

    Take the first element, here 4, and reverse the order of the first 4 elements: {5,1,2,4,3}.

    Repeat this until the first element is a 1, so flipping won't change anything more: {3,4,2,1,5}, {2,4,3,1,5}, {4,2,3,1,5}, {1,3,2,4,5}.

    Count the number of flips, here 5.

    Keep a checksum

        checksum = checksum + (if permutation_index is even then flips_count else -flips_count)

        checksum = checksum + (toggle_sign_-1_1 * flips_count) 

    Do this for all n! permutations, and record the maximum number of flips needed for any permutation. 

diff program output N = 7 with this output file to check your program output has the correct format, before you contribute your program.

Use a larger command line argument (12) to check program performance. 
