
; uint16_t fzx_string_extent_callee(struct fzx_font *ff, char *s)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_string_extent_callee

EXTERN asm_fzx_string_extent

_fzx_string_extent_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_fzx_string_extent
