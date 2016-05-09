
; ===============================================================
; Dec 2013
; ===============================================================
; 
; long strtol( const char * restrict nptr, char ** restrict endptr, int base)
;
; Read number encoded in given radix from string; if base == 0,
; radix is auto-detected as decimal, octal or hex.
;
; Functionality is complicated so best refer to online C docs.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_strtol

EXTERN __strtoul__, error_erange_lmc, error_erange_zc, error_einval_zc

asm_strtol:

   ; enter : bc = int base
   ;         de = char **endp
   ;         hl = char *nptr
   ;
   ; exit  : *endp = bc as detailed below
   ;
   ;         no error:
   ;
   ;           carry reset
   ;           dehl = long result
   ;             bc = char *nptr (& next unconsumed char)
   ;            ixl = base
   ;
   ;         invalid input string or base:
   ;
   ;           carry set
   ;             bc = initial char *nptr
   ;           dehl = 0
   ;            ixl = base
   ;           errno set to EINVAL
   ;
   ;         overflow:
   ;
   ;           carry set
   ;             bc = char *nptr (& next unconsumed char following oversized number)
   ;            ixl = base
   ;           dehl = $7fffffff (LONG_MAX) or $80000000 (LONG_MIN)
   ;           errno set to ERANGE
   ;
   ; uses  : af, bc, de, hl, ix
   
   call __strtoul__
   jr c, check_errors
   
   ; unsigned conversion was successful but signed
   ; number range is narrower so must check again
   
   dec a
   ret z                       ; negative result is in range
   
   bit 7,d                     ; if most significant bit of positive number
   ret z                       ;   is set we are out of range
   
positive_overflow:
   
   jp error_erange_lmc         ; dehl = $7fffffff = LONG_MAX
   
check_errors:

   ; what kind of error was it
   
   dec a
   jp m, error_einval_zc       ; on invalid base or invalid string

   ; overflow occurred
   
   dec a
   jr z, positive_overflow
      
   ld de,$8000
   jp error_erange_zc          ; dehl = $80000000 = LONG_MIN
