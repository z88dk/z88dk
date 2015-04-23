
; int fzx_puts_justified_callee(struct fzx_state *fs, char *s, uint16_t allowed_width)

SECTION code_font_fzx

PUBLIC _fzx_puts_justified_callee

_fzx_puts_justified_callee:

   pop af
   pop ix
   pop hl
   pop bc
   push af
   
   INCLUDE "font/fzx/z80/asm_fzx_puts_justified.asm"
