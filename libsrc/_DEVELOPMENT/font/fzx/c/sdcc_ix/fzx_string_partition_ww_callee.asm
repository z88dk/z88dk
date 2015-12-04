
; char *fzx_string_partition_ww_callee(struct fzx_font *ff, char *s, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_string_partition_ww_callee, l0_fzx_string_partition_ww_callee

EXTERN asm_fzx_string_partition_ww

_fzx_string_partition_ww_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

l0_fzx_string_partition_ww_callee:

   push bc
   ex (sp),ix
   
   call asm_fzx_string_partition_ww
   
   pop ix
   ret
