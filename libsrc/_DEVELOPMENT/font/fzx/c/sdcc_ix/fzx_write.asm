
; int fzx_write(struct fzx_state *fs, char *buf, uint16_t buflen)

SECTION code_font_fzx

PUBLIC _fzx_write

EXTERN l_neg_hl

_fzx_write:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   push hl
   ex (sp),ix
   
   call asm_fzx_write
   
   pop ix
   ret nc
   
   jp l_neg_hl
   
   INCLUDE "font/fzx/z80/asm_fzx_write.asm"
