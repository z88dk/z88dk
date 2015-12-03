
; intmax_t imaxabs(intmax_t j)

SECTION code_clib
SECTION code_inttypes

PUBLIC asm_imaxabs

EXTERN asm_labs

defc asm_imaxabs = asm_labs
