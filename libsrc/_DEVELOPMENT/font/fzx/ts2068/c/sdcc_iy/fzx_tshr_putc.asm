
; int fzx_tshr_putc(struct fzx_tshr_state *fs, int c)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_tshr_putc

EXTERN l0_fzx_tshr_putc_callee

_fzx_tshr_putc:

   pop af
   pop ix
   pop bc
   
   push bc
   push hl
   push af

   jp l0_fzx_tshr_putc_callee
