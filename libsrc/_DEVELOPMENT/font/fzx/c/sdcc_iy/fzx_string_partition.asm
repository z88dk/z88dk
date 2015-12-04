
; char *fzx_string_partition(struct fzx_font *ff, char *s, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_string_partition

EXTERN asm_fzx_string_partition

_fzx_string_partition:

   pop af
   pop ix
   pop de
   pop hl
   
   push hl
   push de
   push hl
   push af
   
   jp asm_fzx_string_partition
