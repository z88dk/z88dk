
; char *fzx_buffer_partition_ww_callee(struct fzx_font *ff, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_buffer_partition_ww_callee

EXTERN asm_fzx_buffer_partition_ww

_fzx_buffer_partition_ww_callee:

   pop hl
   pop ix
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_fzx_buffer_partition_ww
