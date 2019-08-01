; void gotoxy_callee(uint x, uint y)
; 09.2017 stefano

SECTION code_clib
PUBLIC gotoxy_callee
PUBLIC _gotoxy_callee
PUBLIC ASMDISP_GOTOXY_CALLEE

EXTERN __console_x
EXTERN __console_y

.gotoxy_callee
._gotoxy_callee

   pop af
   pop de
   pop bc
   push af

.asmentry

   ; c = x    e = y
   ld	a,c
   ld	(__console_x),a
   ld	a,e
   ld	(__console_y),a

   ret

DEFC ASMDISP_GOTOXY_CALLEE = asmentry - gotoxy_callee
