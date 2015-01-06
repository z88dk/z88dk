
; char *fzx_string_partition_ww(struct fzx_font *ff, char *s, uint16_t allowed_width)

SECTION code_font_fzx

PUBLIC _fzx_string_partition_ww

_fzx_string_partition_ww:

   pop af
   pop ix
   pop de
   pop hl
   
   push hl
   push de
   push ix
   push af
   
   INCLUDE "font/fzx/z80/asm_fzx_string_partition_ww.asm"
