
; void im2_init(void *im2_table)

SECTION code_clib
SECTION code_z80

PUBLIC im2_init

EXTERN asm_im2_init

defc im2_init = asm_im2_init
