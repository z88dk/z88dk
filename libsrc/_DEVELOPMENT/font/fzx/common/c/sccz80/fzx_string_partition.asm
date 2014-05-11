
; char *fzx_string_partition(char *s, uint width)

PUBLIC fzx_string_partition

EXTERN asm_fzx_string_partition

fzx_string_partition:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_fzx_string_partition
