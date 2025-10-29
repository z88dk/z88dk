
; int fzx_write_calle(struct fzx_state *fs, char *buf, uint16_t buflen)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_write_callee, l0_fzx_write_callee

EXTERN l_neg_hl, asm_fzx_write

_fzx_write_callee:

   pop af
   pop ix
   pop de
   pop bc
   push af

l0_fzx_write_callee:

   call asm_fzx_write
   ret nc
   
   jp l_neg_hl
