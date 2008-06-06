; int __CALLEE__ fputs(const char *s, FILE *stream)
; 06.2008 aralbrec

XLIB fputs_callee
XDEF ASMDISP_FPUTS_CALLEE
LIB l_jpix, stdio_error, stdio_success

INCLUDE "stdio.def"

.fputs_callee

   pop hl
   pop ix
   ex (sp),hl

.asmentry

   ; enter : hl = char *s
   ;         ix = FILE *stream
   ; exit  : hl = 1 carry reset for success
   ;         hl = -1 carry set for fail
   ; uses  : af, bc, de, hl, ix
   
   bit 7,(ix+3)                ; valid FILE* ?
   jp z, stdio_error
   
.loop

   ld a,(hl)   
   or a
   jp z, stdio_success
   inc hl

   push hl
   ld b,a
   ld c,STDIO_SERVICE_PUTCHAR
   call l_jpix
   pop hl
   jr nc, loop
   jp stdio_error

defc ASMDISP_FPUTS_CALLEE = asmentry - fputs_callee
