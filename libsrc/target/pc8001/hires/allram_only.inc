; The routines that page the GVRAM in over $8000 - $BFFF are placed at the start
; of the program, which has to be built to run from $0000 (allram). Only the
; allram startup defines this symbol, so linking them into any other program
; fails with an undefined symbol and this name.

    EXTERN  PC8001_HIRES_NEEDS_ALLRAM
    defc    __subtype_protection = PC8001_HIRES_NEEDS_ALLRAM
