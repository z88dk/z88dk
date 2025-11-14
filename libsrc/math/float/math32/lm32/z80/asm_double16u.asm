
SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_double16u

EXTERN m32_float16u

   ; 16-bit unsigned integer to double
   ;
   ; enter : HL = 16-bit unsigned integer n
   ;
   ; exit  : DEHL = DEHL' (exx set saved)
   ;         DEHL'= (float)(n)
   ;
   ; uses  : af, hl, bc', de', hl'

.asm_double16u
    call m32_float16u           ; convert HL to float in DEHL
    exx                         ; bring DEHL' to DEHL
    ret

