
; ===============================================================
; Jan 2014
; ===============================================================
; 
; unsigned int _strtou(const char *nptr, char **endptr, int base)
;
; Read number encoded in given radix from string; if base == 0,
; radix is auto-detected as decimal, octal or hex.
;
; 16-bit version of strtoul.
;
; ===============================================================

XLIB asm__strtou

LIB __strtou, error_erange_mc, error_erange_zc, error_einval_zc

asm__strtou:

   ; enter : bc = int base
   ;         de = char **endp
   ;         hl = char *nptr
   ;
   ; exit  : *endp = de as detailed below
   ;
   ;         no error:
   ;
   ;           carry reset
   ;             hl = uint result
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
   ;             hl = $ffff (UINT_MAX) or $8000 (INT_MIN)
   ;           errno set to ERANGE
   ;
   ; uses  : af, bc, de, hl

   call __strtou
   ret nc                      ; if no errors
   
   ; what kind of error was it

   dec a
   jp m, error_einval_zc       ; on invalid base or invalid string
   jp nz, error_erange_mc      ; on unsigned overflow hl = $ffff = UINT_MAX

   ; signed overflow
   
   call error_erange_zc
   ld h,$80                    ; hl = $8000 = INT_MIN
   ret
