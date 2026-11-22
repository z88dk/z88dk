
; int fzx_puts(struct fzx_state *fs, char *s)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_puts

EXTERN l0_fzx_puts_callee

_fzx_puts:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp l0_fzx_puts_callee
