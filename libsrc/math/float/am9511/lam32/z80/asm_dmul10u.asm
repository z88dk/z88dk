
SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_dmul10u, asm_dmul10a

EXTERN asm_am9511_fmul10u_fastcall

   ; multiply DEHL' by 10 and make positive
   ; 
   ; enter : DEHL'= float x
   ;
   ; exit  : success
   ;
   ;            DEHL'= abs(x) * 10
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            DEHL'= +inf
   ;            carry set, errno set
   ;
   ; uses  : af, bc', de', hl'


defc asm_dmul10a = asm_dmul10u

.asm_dmul10u

    exx
    call asm_am9511_fmul10u_fastcall

    exx
    ret
