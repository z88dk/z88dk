
; int fzx_puts(struct fzx_state *fs, char *s)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_puts_callee, fzx0_puts_callee

EXTERN l_neg_hl, asm_fzx_puts

fzx_puts_callee:

   pop af
   pop de
   ex (sp),ix
   exx
   pop hl
   push af
   push hl
   exx

   call asm_fzx_puts
   jr nc, fzx_puts_callee_ok
   call l_neg_hl

fzx_puts_callee_ok:

   pop ix
   ret

fzx0_puts_callee:

   call asm_fzx_puts
   ret nc

   jp l_neg_hl
