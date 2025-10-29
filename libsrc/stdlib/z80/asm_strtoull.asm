
; ===============================================================
; May 2016
; ===============================================================
; 
; unsigned long long strtoull(const char * restrict nptr, char ** restrict endptr, int base)
;
; Read number encoded in given radix from string; if base == 0,
; radix is auto-detected as decimal, octal or hex.
;
; Functionality is complicated so best refer to online C docs.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_strtoull

EXTERN __strtoull__, error_einval_zc, error_erange_llmc

asm_strtoull:

   ; enter : bc = int base
   ;         de = char **endp
   ;         hl = char *nptr
   ;
   ; exit  : *endp = bc as detailed below
   ;
   ;         no error:
   ;
   ;           carry reset
   ;           dehl'dehl = unsigned long long result
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
   ;            carry set
   ;             bc = char *nptr (& next unconsumed char following oversized number)
   ;           dehl'dehl = $ffffffff ffffffff (ULLONG_MAX)
   ;           errno set to ERANGE
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl', ix

   call __strtoull__
   ret nc                      ; no errors
   
   ; what kind of error was it
   
   dec a
   
   or a
   ret z                       ; signed underflow is not an error
   
   jp m, error_einval_zc       ; on invalid base or invalid string
   
unsigned_overflow:
   
   jp error_erange_llmc        ; dehl'dehl = $ffffffff ffffffff
