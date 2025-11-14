; void tshr_scroll_up(uchar prows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_scroll_up

EXTERN asm_tshr_scroll_up

tshr_scroll_up:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp asm_tshr_scroll_up

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_scroll_up
defc _tshr_scroll_up = tshr_scroll_up
ENDIF

