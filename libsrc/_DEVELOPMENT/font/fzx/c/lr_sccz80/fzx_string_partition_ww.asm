
; char *fzx_string_partition_ww(char *s, uint width)

PUBLIC fzx_string_partition_ww

EXTERN asm_fzx_string_partition_ww

fzx_string_partition_ww:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_fzx_string_partition_ww
