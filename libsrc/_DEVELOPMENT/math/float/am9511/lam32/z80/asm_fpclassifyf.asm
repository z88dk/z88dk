
SECTION code_clib
SECTION code_fp_am9511

PUBLIC	asm_fpclassify, asm_fpclassifyf

EXTERN	asm_am9511_fpclassify

    ; enter : dehl' = float x
    ;
    ; exit  : dehl' = float x
    ;            a  = 0 if number
    ;               = 1 if zero
    ;               = 2 if nan
    ;               = 3 if inf
    ;
    ; uses  : af
    
.asm_fpclassify
.asm_fpclassifyf
    exx
    call asm_am9511_fpclassify

    exx
    ret

