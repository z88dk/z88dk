; void screensize_callee(uchar *x, uchar *y)
; 09.2017 stefano

SECTION code_clib
PUBLIC screensize_callee
PUBLIC _screensize_callee
PUBLIC ASMDISP_SCREENSIZE_CALLEE

EXTERN	text_cols
EXTERN	text_rows


.screensize_callee
._screensize_callee

   pop af
   pop de
   pop bc
   push af

.asmentry

   ; bc = x    de = y
   ld	a,(text_cols)
   ld	(bc),a
   ld	a,(text_rows)
   ld	(de),a

   ret

DEFC ASMDISP_SCREENSIZE_CALLEE = # asmentry - screensize_callee
