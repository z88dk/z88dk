
; char *fzx_string_partition_ww(char *s, uint width)

XDEF fzx_string_partition_ww

fzx_string_partition_ww:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   push ix
   
   call asm_fzx_string_partition_ww
   
   pop ix
   ret
   
   INCLUDE "font/fzx/z80/asm_fzx_string_partition_ww.asm"
