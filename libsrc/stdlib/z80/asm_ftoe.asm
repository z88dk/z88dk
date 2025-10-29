
; ===============================================================
; Jun 2015
; ===============================================================
; 
; size_t ftoe(float x, char *buf, uint16_t prec, uint16_t flag)
;
; (-d.dddde+dd)
;
; An alias for dtoe() since the C compilers do not distinguish
; between float and double currently.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_ftoe

EXTERN asm_dtoe

defc asm_ftoe = asm_dtoe
