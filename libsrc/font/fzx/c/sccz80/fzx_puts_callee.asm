
; int fzx_puts(struct fzx_state *fs, char *s)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_puts_callee, fzx0_puts_callee

EXTERN l_neg_hl, asm_fzx_puts

fzx_puts_callee:

   pop af
   pop de
   pop ix
   push af

fzx0_puts_callee:

   call asm_fzx_puts
   ret nc
   
   jp l_neg_hl
