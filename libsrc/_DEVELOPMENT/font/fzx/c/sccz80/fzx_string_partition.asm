
; char *fzx_string_partition(struct fzx_font *ff, char *s, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC fzx_string_partition

EXTERN asm_fzx_string_partition

fzx_string_partition:

   pop af
   pop hl
   pop de
   pop ix
   
   push hl
   push de
   push hl
   push af
   
   jp asm_fzx_string_partition
