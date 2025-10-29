
; float _negf (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_dneg

EXTERN m32_fsneg

   ; negate  DEHL'
   ;
   ; enter : DEHL'= double x
   ;
   ; exit  : DEHL'= -x
   ;
   ; uses  :

.asm_dneg
    exx
    call m32_fsneg

    exx
    ret
