
; char *fzx_string_partition(char *s, uint width)

SECTION seg_code_fzx

PUBLIC fzx_string_partition_callee

fzx_string_partition_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "font/fzx/zx/z80/asm_fzx_string_partition.asm"
