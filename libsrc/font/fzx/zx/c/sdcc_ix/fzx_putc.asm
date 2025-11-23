
; int fzx_putc(struct fzx_state *fs, int c)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_putc

EXTERN l0_fzx_putc_callee

_fzx_putc:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   jp l0_fzx_putc_callee
