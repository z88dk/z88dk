
; int fzx_tshr_putc(struct fzx_tshr_state *fs, int c)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_tshr_putc

EXTERN fzx0_tshr_putc_callee

fzx_tshr_putc:

   pop af
   pop bc
   pop ix

   push hl
   push bc
   push af
   
   jp fzx0_tshr_putc_callee
