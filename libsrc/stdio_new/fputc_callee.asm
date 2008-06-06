; int __CALLEE__ fputc(int c, FILE *stream)
; 06.2008 aralbrec

XLIB fputc_callee
XDEF ASMDISP_FPUTC_CALLEE
LIB l_jpix, stdio_error

INCLUDE "stdio.def"

.fputc_callee

   pop hl
   pop ix
   ex (sp),hl

.asmentry

   ; enter : ix = FILE *stream
   ;         hl = int c
   ; exit  : hl = char c, carry reset for success
   ;         hl = -1, carry set for fail
   ; uses  : af, bc, de, hl, ix
   
   bit 7,(ix+3)                ; valid FILE* ?
   jp z, stdio_error
   
   push hl                     ; save char
   ld b,l
   ld c,STDIO_SERVICE_PUTCHAR
   call l_jpix
   pop hl
   jp c, stdio_error
   
   ld h,0                      ; hl = char
   ret

defc ASMDISP_FPUTC_CALLEE = asmentry - fputc_callee
