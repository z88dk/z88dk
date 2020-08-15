
SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_dadd

EXTERN asm_am9511_fadd_callee

   ; compute DEHL' = DEHL' + DEHL
   ;
   ; enter : DEHL'= double x
   ;         DEHL = double y
   ;
   ; exit  : DEHL'= double y
   ;
   ;         success
   ;
   ;            DEHL'= x + y
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            DEHL'= +-inf
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

.asm_dadd
    push de
    push hl

    exx
    call asm_am9511_fadd_callee

    exx
    ret

