
SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_dadd

EXTERN m32_fsadd_callee

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
    call m32_fsadd_callee

    exx
    ret

