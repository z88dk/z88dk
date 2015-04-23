
; int fzx_puts_callee(struct fzx_state *fs, char *s)

SECTION code_font_fzx

PUBLIC _fzx_puts_callee, l0_fzx_puts_callee

EXTERN l_neg_hl

_fzx_puts_callee:

   pop af
   pop ix
   pop de
   push af

l0_fzx_puts_callee:

   call asm_fzx_puts
   ret nc
   
   jp l_neg_hl
   
   INCLUDE "font/fzx/z80/asm_fzx_puts.asm"
