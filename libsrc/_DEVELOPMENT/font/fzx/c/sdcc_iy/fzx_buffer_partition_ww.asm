
; char *fzx_buffer_partition_ww(struct fzx_font *ff, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_buffer_partition_ww

EXTERN asm_fzx_buffer_partition_ww

_fzx_buffer_partition_ww:

   pop af
   pop ix
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push hl
   push af
   
   jp asm_fzx_buffer_partition_ww
