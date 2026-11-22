
; char *fzx_buffer_partition_callee(struct fzx_font *ff, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_buffer_partition_callee, l0_fzx_buffer_partition_callee

EXTERN asm_fzx_buffer_partition

_fzx_buffer_partition_callee:

   pop hl
   exx
   pop bc
   exx
   pop de
   pop bc
   ex (sp),hl

l0_fzx_buffer_partition_callee:

   exx
   push bc
   exx
   ex (sp),ix
   
   call asm_fzx_buffer_partition
   
   pop ix
   ret
