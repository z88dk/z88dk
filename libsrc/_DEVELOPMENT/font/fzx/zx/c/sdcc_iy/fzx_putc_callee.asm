
; int fzx_putc_callee(struct fzx_state *fs, int c)

SECTION code_font_fzx

PUBLIC _fzx_putc_callee, l0_fzx_putc_callee

_fzx_putc_callee:

   pop af
   pop ix
   pop bc
   push af

l0_fzx_putc_callee:

   call asm_fzx_putc
   ret nc
   
   ld l,a
   ld h,0
   
   ret
   
   INCLUDE "font/fzx/zx/z80/asm_fzx_putc.asm"
