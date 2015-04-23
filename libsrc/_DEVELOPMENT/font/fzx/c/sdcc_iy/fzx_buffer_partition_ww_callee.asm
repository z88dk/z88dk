
; char *fzx_buffer_partition_ww_callee(struct fzx_font *ff, char *buf, uint16_t buflen, uint16_t allowed_width)

SECTION code_font_fzx

PUBLIC _fzx_buffer_partition_ww_callee

_fzx_buffer_partition_ww_callee:

   pop hl
   pop ix
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "font/fzx/z80/asm_fzx_buffer_partition_ww.asm"
