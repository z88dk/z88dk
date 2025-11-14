
SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_double16u

EXTERN asm_am9511_float16u

   ; 16-bit unsigned integer to double
   ;
   ; enter : HL = 16-bit unsigned integer n
   ;
   ; exit  : DEHL = DEHL' (exx set saved)
   ;         DEHL'= (float)(n)
   ;
   ; uses  : af, hl, bc', de', hl'

.asm_double16u
    call asm_am9511_float16u    ; convert HL to float in DEHL
    exx                         ; bring DEHL' to DEHL
    ret

