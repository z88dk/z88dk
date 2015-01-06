
; char *fzx_string_partition(struct fzx_font *ff, char *s, uint16_t allowed_width)

SECTION code_font_fzx

PUBLIC _fzx_string_partition

_fzx_string_partition:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   push bc
   ex (sp),ix
   
   call asm_fzx_string_partition
   
   pop ix
   ret
   
   INCLUDE "font/fzx/z80/asm_fzx_string_partition.asm"
