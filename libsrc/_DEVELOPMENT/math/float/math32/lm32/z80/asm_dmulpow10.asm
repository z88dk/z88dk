
SECTION code_clib
SECTION code_fp_math32

PUBLIC asm_dmulpow10

EXTERN m32_float8, m32_fsmul_callee
EXTERN _m32_exp10f

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
    call m32_float8             ; convert l to float in dehl
    exx
    
    push de                     ; preserve x, and put it on stack for fsmul
    push hl
    exx
    
    call _m32_exp10f            ; make 10^A
    call m32_fsmul_callee       ; DEHL = x * 10^(A)
    exx
    ret
