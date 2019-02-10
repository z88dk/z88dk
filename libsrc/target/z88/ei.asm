;
;       Small C+ Runtime Library
;
;       Z88 Application functions
;
;       *** Z88 SPECIFIC FUNCTION - probably no equiv for your machine! ***
;
;       11/4/99
;
;       Enable interrupts (used with di to get value)
;       void ei(int)


        SECTION code_clib

               PUBLIC    ei
               PUBLIC    _ei

                INCLUDE "interrpt.def"

.ei
._ei
        pop     bc
        pop     af
        push    af
        push    bc
        call    oz_ei
        ret
        
