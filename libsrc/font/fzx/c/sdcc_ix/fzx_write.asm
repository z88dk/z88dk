
; int fzx_write(struct fzx_state *fs, char *buf, uint16_t buflen)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_write

EXTERN l0_fzx_write_callee

_fzx_write:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp l0_fzx_write_callee
