
; uint16_t fzx_string_extent(struct fzx_font *ff, char *s)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_string_extent

EXTERN asm_fzx_string_extent

fzx_string_extent:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_fzx_string_extent
