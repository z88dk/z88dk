
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int _strtoi(const char *nptr, char **endptr, int base)
;
; Read number encoded in given radix from string; if base == 0,
; radix is auto-detected as decimal, octal or hex.
;
; 16-bit version of strtol.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm__strtoi

EXTERN __strtou__, error_erange_mc, error_erange_zc, error_einval_zc

asm__strtoi:

   ; enter : bc = int base
   ;         de = char **endp
   ;         hl = char *nptr
   ;
   ; exit  : *endp = de as detailed below
   ;
   ;         no error:
   ;
   ;           carry reset
   ;             hl = int result
   ;             de = char *nptr (& next unconsumed char)
   ;
   ;         invalid input string or base:
   ;
   ;           carry set
   ;             de = initial char *nptr
   ;             hl = 0
   ;           errno set to EINVAL
   ;
   ;         overflow:
   ;
   ;           carry set
   ;             de = char *nptr (& next unconsumed char following oversized number)
   ;             hl = $7fff (INT_MAX) or $8000 (INT_MIN)
   ;           errno set to ERANGE
   ;
   ; uses  : af, bc, de, hl
   
   call __strtou__
   jr c, check_errors
   
   ; unsigned conversion was successful but signed
   ; number range is narrower so must check again
   
   dec a
   ret z                       ; negative result is in range
   
   bit 7,h                     ; if most significant bit of positive number
   ret z                       ;   is set we are out of range
   
positive_overflow:
   
   call error_erange_mc
   ld h,$7f                    ; hl = $7fff = INT_MAX
   ret
   
check_errors:

   ; what kind of error was it
   
   dec a
   jp m, error_einval_zc       ; on invalid base or invalid string

   ; overflow occurred
   
   dec a
   jr z, positive_overflow

   call error_erange_zc
   ld h,$80                    ; hl = $8000 = INT_MIN
   ret
