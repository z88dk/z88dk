
; uint16_t fzx_buffer_extent(struct fzx_font *ff, char *buf, uint16_t buflen)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_buffer_extent

EXTERN asm_fzx_buffer_extent

_fzx_buffer_extent:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_fzx_buffer_extent
