
; char *fzx_string_partition_ww(char *s, uint width)

PUBLIC fzx_string_partition_callee

fzx_string_partition_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "font/fzx/z80/asm_fzx_string_partition_ww.asm"
