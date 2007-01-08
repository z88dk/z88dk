; char __CALLEE__ *strcpy_callee(char *dst, char *src)
; copy src to dst including '\0'
; 03.1999 djm, 12.2006 aralbrec

XLIB strcpy_callee
XDEF ASMDISP_STRCPY_CALLEE

.strcpy_callee

   pop bc
   pop hl
   pop de
   push bc
   
   ; enter : hl = char *src
   ;         de = char *dst
   ; exit  : hl = char *dst
   ; uses  : af, bc, de, hl
   
.asmentry

   push de

.loop

   ld a,(hl)
   ldi
   or a
   jp nz, loop
   
   pop hl
   ret

DEFC ASMDISP_STRCPY_CALLEE = asmentry - strcpy_callee
