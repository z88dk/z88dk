
; int fzx_puts_justified(struct fzx_state *fs, char *s, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_puts_justified

EXTERN asm_fzx_puts_justified

_fzx_puts_justified:

   pop af
   pop ix
   pop hl
   pop bc
   
   push bc
   push hl
   push hl
   push af
   
   jp asm_fzx_puts_justified
