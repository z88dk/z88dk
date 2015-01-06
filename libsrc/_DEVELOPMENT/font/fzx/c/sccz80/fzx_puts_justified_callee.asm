
; int fzx_puts_justified(struct fzx_state *fs, char *s, uint16_t allowed_width)

SECTION code_font_fzx

PUBLIC fzx_puts_justified_callee

fzx_puts_justified_callee:

   pop af
   pop bc
   pop hl
   pop ix
   push af
   
   INCLUDE "font/fzx/z80/asm_fzx_puts_justified.asm"
