
; void fzx_at(struct fzx_state *fs, uint16_t x, uint16_t y)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_at

EXTERN asm_fzx_at

fzx_at:

   pop af
   pop bc
   pop hl
   pop ix
   
   push hl
   push hl
   push bc
   push af
   
   jp asm_fzx_at
