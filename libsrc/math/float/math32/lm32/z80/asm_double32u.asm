
SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_double32u

EXTERN m32_float32u

   ; 32-bit unsigned integer to double
   ;
   ; enter : DEHL = 32-bit unsigned integer n
   ;
   ; exit  : DEHL = DEHL' (exx set saved)
   ;         DEHL'= (float)(n)
   ;
   ; uses  : af, hl, bc', de', hl'

.asm_double32u
    push de
    push hl

    exx
    pop hl
    pop de
    call m32_float32u           ; convert dehl to float in dehl

    exx
    ret

