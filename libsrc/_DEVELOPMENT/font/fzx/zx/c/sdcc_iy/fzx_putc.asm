
; int fzx_putc(struct fzx_state *fs, int c)

SECTION code_font_fzx

PUBLIC _fzx_putc

_fzx_putc:

   pop af
   pop ix
   pop bc
   
   push bc
   push ix
   push af
   
   call asm_fzx_putc
   ret nc
   
   ld l,a
   ld h,0
   
   ret
   
   INCLUDE "font/fzx/zx/z80/asm_fzx_putc.asm"
