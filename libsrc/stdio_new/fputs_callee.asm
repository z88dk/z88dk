; int __CALLEE__ fputs(const char *s, FILE *stream)
; 06.2008 aralbrec

XLIB fputs_callee
XDEF ASMDISP_FPUTS_CALLEE
LIB l_jpix, stdio_error_mc, stdio_success_znc, stdio_error_eacces_mc

INCLUDE "stdio.def"

.fputs_callee

   pop hl
   pop ix
   ex (sp),hl

.asmentry

   ; enter : hl = char *s
   ;         ix = FILE *stream
   ; exit  : hl = 0 carry reset for success
   ;         hl = -1 carry set for fail
   ; uses  : af, bc, de, hl, ix
   
   bit 1,(ix+3)                ; open for output?
   jp z, stdio_error_eacces_mc

.loop

   ld a,(hl)   
   or a
   jp z, stdio_success_znc
   inc hl

   push hl
   ld b,a
   ld c,STDIO_MSG_PUTC
   call l_jpix
   pop hl
   jr nc, loop
   jp stdio_error_mc

defc ASMDISP_FPUTS_CALLEE = asmentry - fputs_callee
