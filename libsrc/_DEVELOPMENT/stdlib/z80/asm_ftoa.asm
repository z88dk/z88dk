
; ===============================================================
; Jun 2015
; ===============================================================
; 
; size_t ftoa(float x, char *buf, uint16_t prec, uint16_t flag)
;
; (-ddd.ddd)
;
; An alias for dtoa() since the C compilers do not distinguish
; between float and double currently.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_ftoa

EXTERN asm_dtoa

defc asm_ftoa = asm_dtoa
