
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

SECTION code_clib
SECTION code_stdlib

PUBLIC asm__strtou

EXTERN __strtou__, error_erange_mc, error_einval_zc

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
   ;             hl = $ffff (UINT_MAX)
   ;           errno set to ERANGE
   ;
   ; uses  : af, bc, de, hl

   call __strtou__
   ret nc                      ; if no errors
   
   ; what kind of error was it

   dec a
   
   or a
   ret z                       ; signed underflow is not an error
      
   jp m, error_einval_zc       ; on invalid base or invalid string

   ; unsigned overflow
   
   jp error_erange_mc          ; hl = $ffff = UINT_MAX
