
; uint16_t fzx_buffer_extent(struct fzx_font *ff, char *buf, uint16_t buflen)

SECTION code_font_fzx

PUBLIC fzx_buffer_extent_callee

fzx_buffer_extent_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "font/fzx/z80/asm_fzx_buffer_extent.asm"
