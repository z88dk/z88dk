
SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_dmul10a

EXTERN m32_fsmul10a_fastcall

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
   ; uses  : af, af', bc', de', hl'

.asm_dmul10a
    push bc
    push de
    push hl

    exx
    call m32_fsmul10a_fastcall

    exx
    pop hl
    pop de
    pop bc
    ret

