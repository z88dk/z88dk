
; int fzx_puts_justified_callee(struct fzx_state *fs, char *s, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_puts_justified_callee

EXTERN asm_fzx_puts_justified

_fzx_puts_justified_callee:

   pop af
   pop ix
   pop hl
   pop bc
   push af
   
   jp asm_fzx_puts_justified
