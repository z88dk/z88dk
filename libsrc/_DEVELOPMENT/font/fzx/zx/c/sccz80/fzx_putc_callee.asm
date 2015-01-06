
; int fzx_putc(struct fzx_state *fs, int c)

SECTION code_font_fzx

PUBLIC fzx_putc_callee, fzx0_putc_callee

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

   INCLUDE "font/fzx/zx/z80/asm_fzx_putc.asm"
