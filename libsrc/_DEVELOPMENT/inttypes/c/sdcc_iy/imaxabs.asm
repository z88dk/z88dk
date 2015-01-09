
; intmax_t imaxabs(intmax_t j)

SECTION code_inttypes

PUBLIC _imaxabs

EXTERN _labs

defc _imaxabs = _labs

INCLUDE "inttypes/z80/asm_imaxabs.asm"
