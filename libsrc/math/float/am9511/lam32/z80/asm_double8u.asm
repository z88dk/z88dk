
SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_double8u

EXTERN asm_am9511_float8u

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
    call asm_am9511_float8u     ; convert l to float in dehl

    exx
    ret

