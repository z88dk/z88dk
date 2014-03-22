
; char *fzx_string_partition_ww(char *s, uint width)

XDEF fzx_string_partition_ww

fzx_string_partition_ww:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   push ix
   
   call asm_fzx_string_partition_ww
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_fzx_string_partition_ww.asm"
