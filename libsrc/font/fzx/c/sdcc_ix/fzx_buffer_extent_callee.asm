
; uint16_t fzx_buffer_extent_callee(struct fzx_font *ff, char *buf, uint16_t buflen)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_buffer_extent_callee

EXTERN asm_fzx_buffer_extent

_fzx_buffer_extent_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_fzx_buffer_extent
