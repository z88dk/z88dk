; void gotoxy_callee(uint x, uint y)
; 09.2017 stefano

SECTION code_clib
PUBLIC gotoxy_callee
PUBLIC _gotoxy_callee
PUBLIC ASMDISP_GOTOXY_CALLEE

EXTERN ansi_COLUMN
EXTERN ansi_ROW

.gotoxy_callee
._gotoxy_callee

   pop af
   pop de
   pop bc
   push af

.asmentry

   ; c = x    e = y
   ld	a,c
   dec	a
   ld	(ansi_COLUMN),a
   ld	a,e
   dec	a
   ld	(ansi_ROW),a

   ret

DEFC ASMDISP_GOTOXY_CALLEE = # asmentry - gotoxy_callee
