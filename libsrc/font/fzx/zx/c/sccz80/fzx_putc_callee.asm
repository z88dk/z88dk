
; int fzx_putc(struct fzx_state *fs, int c)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_putc_callee, fzx0_putc_callee

EXTERN asm_fzx_putc

fzx_putc_callee:

   pop af
   pop bc
   pop ix
   push af

fzx0_putc_callee:

   call asm_fzx_putc
   ret nc
   
   ld l,a
   ld h,0
   
   ret
