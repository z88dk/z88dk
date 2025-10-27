
; ===============================================================
; Jun 2015
; ===============================================================
; 
; float strtof(const char *nptr, char **endptr)
;
; Read float from string per C11.
;
; An alias for strtod() since the C compilers do not distinguish
; between float and double currently.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_strtof

EXTERN asm_strtod

defc asm_strtof = asm_strtod
