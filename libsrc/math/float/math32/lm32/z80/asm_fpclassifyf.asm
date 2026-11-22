
SECTION code_clib
SECTION code_fp_math32

PUBLIC	asm_fpclassify, asm_fpclassifyf

EXTERN	m32_fpclassify

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
    call m32_fpclassify

    exx
    ret

