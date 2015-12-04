
; int fzx_puts_callee(struct fzx_state *fs, char *s)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_puts_callee, l0_fzx_puts_callee

EXTERN l_neg_hl, asm_fzx_puts

_fzx_puts_callee:

   pop af
   pop hl
   pop de
   push af

l0_fzx_puts_callee:

   push hl
   ex (sp),ix
   
   call asm_fzx_puts
   
   pop ix
   ret nc
   
   jp l_neg_hl
