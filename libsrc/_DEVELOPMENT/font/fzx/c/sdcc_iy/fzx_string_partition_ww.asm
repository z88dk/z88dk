
; char *fzx_string_partition_ww(char *s, uint width)

PUBLIC _fzx_string_partition_ww

_fzx_string_partition_ww:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "font/fzx/z80/asm_fzx_string_partition_ww.asm"
