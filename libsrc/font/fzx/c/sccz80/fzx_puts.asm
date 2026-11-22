
; int fzx_puts(struct fzx_state *fs, char *s)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_puts

EXTERN fzx0_puts_callee

fzx_puts:

   pop af
   pop de
   pop ix
   
   push hl
   push de
   push af
   
   jp fzx0_puts_callee
