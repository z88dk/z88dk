
SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_dmulpow10

EXTERN asm_am9511_float8, asm_am9511_fmul_callee
EXTERN _am9511_exp10

   ; multiply DEHL' by a power of ten
   ; DEHL' *= 10^(A)
   ;
   ; enter : DEHL'= float x
   ;            A = signed char
   ;
   ; exit  : success
   ;
   ;         DEHL'= x * 10^(A)
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;         DEHL'= +-inf
   ;            carry set, errno set
   ;
   ; note  : current implementation may limit power of ten
   ;         to max one-sided range (eg +-38)
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

.asm_dmulpow10
    ld l,a
    call asm_am9511_float8      ; convert l to float in dehl
    exx
    
    push de                     ; preserve x, and put it on stack for fsmul
    push hl
    exx
    
    call _am9511_exp10          ; make 10^A
    call asm_am9511_fmul_callee ; DEHL = x * 10^(A)
    exx
    ret
