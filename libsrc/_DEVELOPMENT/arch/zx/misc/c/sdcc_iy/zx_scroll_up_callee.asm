
; void zx_scroll_up_callee(uint rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_scroll_up_callee

EXTERN asm_zx_scroll_up

_zx_scroll_up_callee:

   pop hl
   pop de
   dec sp
   ex (sp),hl
   
   ld l,h
   jp asm_zx_scroll_up
