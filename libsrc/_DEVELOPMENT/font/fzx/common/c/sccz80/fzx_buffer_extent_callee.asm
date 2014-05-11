
; uint fzx_buffer_extent(void *buf, uint len)

PUBLIC fzx_buffer_extent_callee

fzx_buffer_extent_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "font/fzx/common/z80/asm_fzx_buffer_extent.asm"
