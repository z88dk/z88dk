; void tshc_scroll_up(uchar prows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_scroll_up_callee

EXTERN asm0_tshc_scroll_up

tshc_scroll_up_callee:

   pop af
   pop hl
   pop de
   push af

   jp asm0_tshc_scroll_up

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_scroll_up_callee
defc _tshc_scroll_up_callee = tshc_scroll_up_callee
ENDIF

