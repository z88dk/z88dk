
; int fzx_write(struct fzx_state *fs, char *buf, uint16_t buflen)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_write

EXTERN fzx0_write_callee

fzx_write:

   pop af
   pop bc
   pop de
   pop ix
   
   push hl
   push de
   push bc
   push af
   
   jp fzx0_write_callee
