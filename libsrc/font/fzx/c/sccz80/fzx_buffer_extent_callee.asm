
; uint16_t fzx_buffer_extent(struct fzx_font *ff, char *buf, uint16_t buflen)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_buffer_extent_callee

EXTERN asm_fzx_buffer_extent

fzx_buffer_extent_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_fzx_buffer_extent
