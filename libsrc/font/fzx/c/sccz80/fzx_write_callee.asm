
; int fzx_write(struct fzx_state *fs, char *buf, uint16_t buflen)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_write_callee
PUBLIC fzx0_write_callee

EXTERN l_neg_hl, asm_fzx_write

fzx_write_callee:

   pop af
   pop bc
   pop de
   pop ix
   push af

fzx0_write_callee:

   call asm_fzx_write
   ret nc
   
   jp l_neg_hl
