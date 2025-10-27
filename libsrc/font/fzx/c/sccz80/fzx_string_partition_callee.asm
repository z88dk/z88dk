
; char *fzx_string_partition(struct fzx_font *ff, char *s, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_string_partition_callee

EXTERN asm_fzx_string_partition

fzx_string_partition_callee:

   pop af
   pop hl
   pop de
   pop ix
   push af
   
   jp asm_fzx_string_partition
