
; void im2_init(void *im2_table)

SECTION code_clib
SECTION code_z80

PUBLIC _im2_init

EXTERN asm_im2_init

_im2_init:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_im2_init
