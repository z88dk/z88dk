
; int fzx_puts_justified(struct fzx_state *fs, char *s, uint16_t allowed_width)

SECTION code_font_fzx

PUBLIC _fzx_puts_justified

_fzx_puts_justified:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   push de
   ex (sp),ix
   
   call asm_fzx_puts_justified
   
   pop ix
   ret
   
   INCLUDE "font/fzx/z80/asm_fzx_puts_justified.asm"
