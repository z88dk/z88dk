
; float _negf (float number) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_dneg

EXTERN asm_am9511_neg

   ; negate  DEHL'
   ;
   ; enter : DEHL'= double x
   ;
   ; exit  : DEHL'= -x
   ;
   ; uses  :

.asm_dneg
    exx
    call asm_am9511_neg

    exx
    ret
