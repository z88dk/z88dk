; void tshr_scroll_up(uchar prows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_scroll_up_callee

EXTERN asm_tshr_scroll_up

_tshr_scroll_up_callee:

   pop hl
   ex (sp),hl
   
   ld e,l
   ld l,h
   ld d,0
   jp asm_tshr_scroll_up
