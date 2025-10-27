
; uint16_t fzx_string_extent(struct fzx_font *ff, char *s)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_string_extent_callee

EXTERN asm_fzx_string_extent

fzx_string_extent_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_fzx_string_extent
