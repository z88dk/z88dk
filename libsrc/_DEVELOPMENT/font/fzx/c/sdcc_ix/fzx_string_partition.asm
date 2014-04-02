
; char *fzx_string_partition(char *s, uint width)

XDEF _fzx_string_partition

_fzx_string_partition:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   push ix
   
   call asm_fzx_string_partition
   
   pop ix
   ret
   
   INCLUDE "font/fzx/z80/asm_fzx_string_partition.asm"
