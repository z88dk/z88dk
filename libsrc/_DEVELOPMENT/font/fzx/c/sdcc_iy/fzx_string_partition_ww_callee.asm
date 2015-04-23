
; char *fzx_string_partition_ww_callee(struct fzx_font *ff, char *s, uint16_t allowed_width)

SECTION code_font_fzx

PUBLIC _fzx_string_partition_ww_callee

_fzx_string_partition_ww_callee:

   pop hl
   pop ix
   pop de
   ex (sp),hl
   
   INCLUDE "font/fzx/z80/asm_fzx_string_partition_ww.asm"
