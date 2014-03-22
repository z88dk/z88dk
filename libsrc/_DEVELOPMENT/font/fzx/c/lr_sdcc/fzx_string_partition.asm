
; char *fzx_string_partition(char *s, uint width)

XDEF fzx_string_partition

fzx_string_partition:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   push ix
   
   call asm_fzx_string_partition
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_fzx_string_partition.asm"
