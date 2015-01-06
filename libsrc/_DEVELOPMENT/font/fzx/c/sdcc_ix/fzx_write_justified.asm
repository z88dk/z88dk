
; int fzx_write_justified(struct fzx_state *fs, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font_fzx

PUBLIC _fzx_write_justified

_fzx_write_justified:

   pop af
   exx
   pop bc
   exx
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push bc
   push af
   
   exx
   push bc
   exx
   ex (sp),ix
   
   call asm_fzx_write_justified
   
   pop ix
   ret
   
   INCLUDE "font/fzx/z80/asm_fzx_write_justified.asm"
