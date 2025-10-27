
; char *fzx_buffer_partition(struct fzx_font *ff, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font
SECTION code_font_fzx

PUBLIC _fzx_buffer_partition

EXTERN l0_fzx_buffer_partition_callee

_fzx_buffer_partition:

   pop af
   exx
   pop bc
   exx
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push bc
   push af

   jp l0_fzx_buffer_partition_callee
