
; char *fzx_buffer_partition(struct fzx_font *ff, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_buffer_partition_callee

EXTERN asm_fzx_buffer_partition

fzx_buffer_partition_callee:

   pop af
   pop hl
   pop bc
   pop de
   pop ix
   push af
   
   jp asm_fzx_buffer_partition
