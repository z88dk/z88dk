
; uint16_t fzx_buffer_extent(struct fzx_font *ff, char *buf, uint16_t buflen)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_buffer_extent

EXTERN asm_fzx_buffer_extent

fzx_buffer_extent:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_fzx_buffer_extent
