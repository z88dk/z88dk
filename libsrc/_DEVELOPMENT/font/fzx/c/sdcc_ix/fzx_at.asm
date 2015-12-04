
; void fzx_at(struct fzx_state *fs, uint16_t x, uint16_t y)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_at

EXTERN l0_fzx_at_callee

_fzx_at:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af

   jp l0_fzx_at_callee
