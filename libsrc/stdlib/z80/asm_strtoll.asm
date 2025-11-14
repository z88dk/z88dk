
; ===============================================================
; May 2016
; ===============================================================
; 
; long long strtoll( const char * restrict nptr, char ** restrict endptr, int base)
;
; Read number encoded in given radix from string; if base == 0,
; radix is auto-detected as decimal, octal or hex.
;
; Functionality is complicated so best refer to online C docs.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_strtoll

EXTERN __strtoull__, error_erange_mc, error_erange_zc, error_einval_zc, error_llmc, error_llzc

asm_strtoll:

   ; enter : bc = int base
   ;         de = char **endp
   ;         hl = char *nptr
   ;
   ; exit  : *endp = bc as detailed below
   ;
   ;         no error:
   ;
   ;           carry reset
   ;           dehl'dehl = long long result
   ;             bc = char *nptr (& next unconsumed char)
   ;
   ;         invalid input string or base:
   ;
   ;           carry set
   ;             bc = initial char *nptr
   ;           dehl'dehl = 0
   ;           errno set to EINVAL
   ;
   ;         overflow:
   ;
   ;           carry set
   ;             bc = char *nptr (& next unconsumed char following oversized number)
   ;           dehl'dehl = $7fffffff ffffffff (LLONG_MAX) or $80000000 00000000 (LLONG_MIN)
   ;           errno set to ERANGE
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl', ix
   
   call __strtoull__
   jr c, check_errors
   
   ; unsigned conversion was successful but signed
   ; number range is narrower so must check again
   
   dec a
   ret z                       ; negative result is in range
   
   exx
   bit 7,d                     ; if most significant bit of positive number is set we are out of range
   exx
   ret z
   
positive_overflow:
   
   call error_llmc
   
   exx
   ld d,$7f
   exx
   
   jp error_erange_mc          ; dehl = $7fffffff ffffffff = LLONG_MAX
   
check_errors:

   ; what kind of error was it
   
   dec a
   jp m, error_einval_zc       ; on invalid base or invalid string

overflow:

   ; overflow occurred
   
   dec a
   jr z, positive_overflow

   call error_llzc
   
   exx
   ld d,$80
   exx
   
   jp error_erange_zc          ; dehl = $80000000 00000000 = LLONG_MIN
