
; intmax_t imaxabs(intmax_t j)

SECTION code_inttypes

PUBLIC imaxabs

EXTERN labs

defc imaxabs = labs

INCLUDE "inttypes/z80/asm_imaxabs.asm"
