; char __CALLEE__ *strcpy_callee(char *dst, char *src)
; copy src to dst including '\0'
; 03.1999 djm, 12.2006 aralbrec

SECTION code_clib
PUBLIC strcpy_callee
PUBLIC _strcpy_callee
PUBLIC ASMDISP_STRCPY_CALLEE

.strcpy_callee
._strcpy_callee

   pop hl
   pop de
   ex (sp),hl
   ex  de,hl
   
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

DEFC ASMDISP_STRCPY_CALLEE = # asmentry - strcpy_callee
