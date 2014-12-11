
; int fzx_putc(uchar c)

SECTION code_font_fzx

PUBLIC _fzx_putc

_fzx_putc:

   pop af
   pop hl
   
   push hl
   push af

   ld a,l
   
   INCLUDE "font/fzx/zx/z80/asm_fzx_putc.asm"
