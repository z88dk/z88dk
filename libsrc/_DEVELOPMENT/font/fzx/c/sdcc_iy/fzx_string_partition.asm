
; char *fzx_string_partition(char *s, uint width)

XDEF fzx_string_partition

fzx_string_partition:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "font/fzx/z80/asm_fzx_string_partition.asm"
