
; ===============================================================
; Jun 2015
; ===============================================================
; 
; double atof(const char *nptr)
;
; Convert initial portion of string nptr to double.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_atof

EXTERN asm_strtod

asm_atof:

   ; enter : hl = char *nptr
   ;
   ; exit  : de = char * (first unconsumed char)
   ;         *endp as per C11
   ;
   ;         success
   ;
   ;            AC' = double x
   ;            carry reset
   ;
   ;         fail if range error
   ;
   ;            exx = +- infinity
   ;            carry set, errno = ERANGE
   ;
   ;         fail if invalid string
   ;
   ;            exx = 0.0
   ;            carry set, errno = EINVAL
   ;
   ;         fail if nan not supported
   ;
   ;            exx = 0.0
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'
   
   ld de,0
   jp asm_strtod
