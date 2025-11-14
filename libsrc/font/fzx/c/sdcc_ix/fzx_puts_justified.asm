
; int fzx_puts_justified(struct fzx_state *fs, char *s, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_puts_justified

EXTERN l0_fzx_puts_justified_callee

_fzx_puts_justified:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af

   jp l0_fzx_puts_justified_callee
