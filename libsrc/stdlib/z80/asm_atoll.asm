
; ===============================================================
; May 2016
; ===============================================================
; 
; long long atoll(const char *buf)
;
; Read the initial portion of the string as decimal long long and
; return value read.  Any initial whitespace is skipped.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_atoll

EXTERN asm_strtoll

asm_atoll:

   ; enter : hl = char *nptr
   ;
   ; exit  : no error:
   ;
   ;           carry reset
   ;           dehl'dehl = long long result
   ;
   ;         invalid input string:
   ;
   ;           carry set
   ;           dehl'dehl = 0
   ;           errno set to EINVAL
   ;
   ;         overflow:
   ;
   ;           carry set
   ;           dehl'dehl = $7fffffff ffffffff (LLONG_MAX) or $80000000 00000000 (LLONG_MIN)
   ;           errno set to ERANGE
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl', ix
   
   ld bc,10                    ; base = 10
   ld de,0                     ; endp = 0
   
   jp asm_strtoll
