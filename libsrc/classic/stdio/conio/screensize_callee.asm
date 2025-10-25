; void screensize_callee(uchar *x, uchar *y)
; 09.2017 stefano

SECTION code_clib
PUBLIC screensize_callee
PUBLIC _screensize_callee
PUBLIC asm_screensize

EXTERN	__console_w
EXTERN	__console_h


.screensize_callee
._screensize_callee

   pop hl
   pop de
   pop bc
   push hl

.asm_screensize

   ; bc = x    de = y
   ld	a,(__console_w)
   ld	(bc),a
   inc  bc
   xor  a
   ld   (bc),a
   ld	a,(__console_h)
   ld	(de),a
   inc  de
   xor  a
   ld   (de),a

   ret

