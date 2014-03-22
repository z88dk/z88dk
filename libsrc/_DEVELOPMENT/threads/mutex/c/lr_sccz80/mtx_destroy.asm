
; void mtx_destroy(mtx_t *m)

XDEF mtx_destroy

defc mtx_destroy = asm_mtx_destroy

INCLUDE "../../z80/asm_mtx_destroy.asm"
