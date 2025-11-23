
; ===============================================================
; Jun 2015
; ===============================================================
; 
; size_t ftoh(float x, char *buf, uint16_t prec, uint16_t flag)
;
; (-0xh.hhhp+d)
;
; An alias for dtoh() since the C compilers do not distinguish
; between float and double currently.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_ftoh

EXTERN asm_dtoh

defc asm_ftoh = asm_dtoh
