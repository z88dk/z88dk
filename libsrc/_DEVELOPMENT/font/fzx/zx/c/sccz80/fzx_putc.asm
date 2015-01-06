
; int fzx_putc(struct fzx_state *fs, int c)

SECTION code_font_fzx

PUBLIC fzx_putc

EXTERN fzx0_putc_callee

fzx_putc:

   pop af
   pop bc
   pop ix

   push ix
   push bc
   push af
   
   jp fzx0_putc_callee
