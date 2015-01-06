
; void fzx_at(struct fzx_state *fs, uint16_t x, uint16_t y)

SECTION code_font_fzx

PUBLIC _fzx_at

_fzx_at:

   pop af
   pop ix
   pop hl
   pop bc
   
   push bc
   push hl
   push ix
   push af
   
   INCLUDE "font/fzx/z80/asm_fzx_at.asm"
