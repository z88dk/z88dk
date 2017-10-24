; void tshr_scroll_up(uchar prows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_scroll_up_callee

EXTERN asm_tshr_scroll_up

tshr_scroll_up_callee:

   pop af
   pop hl
   pop de
   push af

   jp asm_tshr_scroll_up
