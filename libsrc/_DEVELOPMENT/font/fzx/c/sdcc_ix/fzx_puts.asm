
; int fzx_puts(struct fzx_state *fs, char *s)

SECTION code_font_fzx

PUBLIC _fzx_puts

EXTERN l_neg_hl

_fzx_puts:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   push hl
   ex (sp),ix
   
   call asm_fzx_puts
   
   pop ix
   ret nc
   
   jp l_neg_hl
   
   INCLUDE "font/fzx/z80/asm_fzx_puts.asm"
