
ERROR
Exit points from subroutines

These functions are meant as a convenient exit from a function.

Exit functions terminating in "_zc", "_znc", "_mc", "_mnc" set the HL register to be zero or minus one and the carry flag to the state indicated.

Exit functions containing a standard C errno name as in "_einval_" also set the thread's errno to the error indicated.

All exit functions allow the stack to be adjusted by a known number of pops by jumping to their entry points minus the number of pops desired.

So, eg, a jump to "error_einval_zc - 2" will pop two items off the stack, set errno equal to EINVAL and return to the caller with HL=0 and carry flag set.

Before performing such a pop-jump, examine the source code to ensure that the exit function has enough pops prior to its entry point. Most will have 1-3 pops available.
