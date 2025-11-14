
; void im2_init_fastcall(void *im2_table)

SECTION code_clib
SECTION code_z80

PUBLIC _im2_init_fastcall

EXTERN asm_im2_init

defc _im2_init_fastcall = asm_im2_init
