
; void fzx_at_callee(struct fzx_state *fs, uint16_t x, uint16_t y)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_at

EXTERN asm_fzx_at

_fzx_at:

   pop af
   pop ix
   pop hl
   pop bc
   push af
   
   jp asm_fzx_at
