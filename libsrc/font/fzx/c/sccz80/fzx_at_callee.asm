
; void fzx_at(struct fzx_state *fs, uint16_t x, uint16_t y)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_at_callee

EXTERN asm_fzx_at

fzx_at_callee:

   pop af
   pop bc
   pop hl
   pop ix
   push af
   
   jp asm_fzx_at
