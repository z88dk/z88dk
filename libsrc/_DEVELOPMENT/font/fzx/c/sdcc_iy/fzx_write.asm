
; int fzx_write(struct fzx_state *fs, char *buf, uint16_t buflen)

SECTION code_font_fzx

PUBLIC _fzx_write

EXTERN l_neg_hl

_fzx_write:

   pop af
   pop ix
   pop de
   pop bc
   
   push bc
   push de
   push ix
   push af

   call asm_fzx_write
   ret nc
   
   jp l_neg_hl
   
   INCLUDE "font/fzx/z80/asm_fzx_write.asm"
