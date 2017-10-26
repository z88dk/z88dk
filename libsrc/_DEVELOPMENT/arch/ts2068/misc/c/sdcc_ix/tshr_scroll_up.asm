; void tshr_scroll_up(uchar prows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_scroll_up

EXTERN asm_tshr_scroll_up

_tshr_scroll_up:

   pop af
   pop de
   
   push de
   push af
   
   ld l,d
   ld d,0
   jp asm_tshr_scroll_up
