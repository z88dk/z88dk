
; ===============================================================
; Dec 2013
; ===============================================================
; 
; unsigned long strtoul( const char * restrict nptr, char ** restrict endptr, int base)
;
; Read number encoded in given radix from string; if base == 0,
; radix is auto-detected as decimal, octal or hex.
;
; Functionality is complicated so best refer to online C docs.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_strtoul

EXTERN __strtoul__, error_einval_zc, error_erange_lmc

asm_strtoul:

   ; enter : bc = int base
   ;         de = char **endp
   ;         hl = char *nptr
   ;
   ; exit  : *endp = bc as detailed below
   ;
   ;         no error:
   ;
   ;           carry reset
   ;           dehl = unsigned long result
   ;             bc = char *nptr (& next unconsumed char)
   ;            ixl = base
   ;
   ;         invalid input string or base:
   ;
   ;           carry set
   ;             bc = initial char *nptr
   ;            ixl = base
   ;           dehl = 0
   ;           errno set to EINVAL
   ;           
   ;         overflow:
   ;
   ;            carry set
   ;             bc = char *nptr (& next unconsumed char following oversized number)
   ;            ixl = base
   ;           dehl = $ffffffff (ULONG_MAX)
   ;           errno set to ERANGE
   ;
   ; uses  : af, bc, de, hl, ix

   call __strtoul__
   ret nc                      ; no errors
   
   ; what kind of error was it
   
   dec a
   
   or a
   ret z                       ; signed underflow is not an error
   
   jp m, error_einval_zc       ; on invalid base or invalid string
   
unsigned_overflow:

   jp error_erange_lmc         ; dehl = $ffffffff = ULONG_MAX
