
SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_dmul

EXTERN asm_am9511_fmul_callee

   ; compute DEHL' = DEHL * DEHL'
   ;
   ; enter : DEHL'= double x
   ;         DEHL = double y
   ;
   ; exit  : DEHL = double y
   ;
   ;         success
   ;
   ;            DEHL'= x*y
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            DEHL'= +-inf
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

.asm_dmul
    push de
    push hl

    exx
    call asm_am9511_fmul_callee

    exx
    ret

