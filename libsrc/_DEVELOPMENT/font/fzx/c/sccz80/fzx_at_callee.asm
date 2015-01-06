
; void fzx_at(struct fzx_state *fs, uint16_t x, uint16_t y)

SECTION code_font_fzx

PUBLIC fzx_at_callee

fzx_at_callee:

   pop af
   pop bc
   pop hl
   pop ix
   push af
   
   INCLUDE "font/fzx/z80/asm_fzx_at.asm"
