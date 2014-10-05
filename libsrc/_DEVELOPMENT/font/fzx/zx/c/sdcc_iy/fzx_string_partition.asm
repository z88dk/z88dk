
; char *fzx_string_partition(char *s, uint width)

SECTION seg_code_fzx

PUBLIC _fzx_string_partition

_fzx_string_partition:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "font/fzx/zx/z80/asm_fzx_string_partition.asm"
