
; ===============================================================
; Jun 2015
; ===============================================================
; 
; size_t ftog(float x, char *buf, uint16_t prec, uint16_t flag)
;
; Use either %f or %e format depending on rules in standard.
;
; An alias for dtog() since the C compilers do not distinguish
; between float and double currently.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_ftog

EXTERN asm_dtog

defc asm_ftog = asm_dtog
