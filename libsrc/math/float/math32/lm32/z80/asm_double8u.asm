
SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_double8u

EXTERN m32_float8u

   ; 8-bit unsigned integer to double
   ;
   ; enter : L = 8-bit unsigned integer n
   ;
   ; exit  : DEHL = DEHL' (exx set saved)
   ;         DEHL'= (float)(n)
   ;
   ; uses  : af, hl, bc', de', hl'

.asm_double8u
    push hl

    exx
    pop hl
    call m32_float8u           ; convert l to float in dehl

    exx
    ret

