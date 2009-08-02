; int __CALLEE__ fputs(const char *s, FILE *stream)
; 07.2009 aralbrec

XLIB fputs_callee
XDEF ASMDISP_FPUTS_CALLEE

LIB strlen, l_jpix
LIB stdio_error_mc, stdio_success_znc, stdio_error_eacces_mc

INCLUDE "../stdio.def"

.fputs_callee

   pop hl
   pop ix
   ex (sp),hl

.asmentry

   ; enter : hl = char *s
   ;         ix = FILE *stream
   ; exit  : hl = 0 and carry reset for success
   ;         hl = -1 and carry set for fail
   ; uses  : af, bc, de, hl, ix
   
   bit 1,(ix+3)                ; open for output?
   jp z, stdio_error_eacces_mc

   ld e,l
   ld d,h                      ; de = char *s
   
   call strlen                 ; hl = length
   jp z, stdio_success_znc     ; 0 len = success already!

   ; de = char *s
   ; hl = length
   ; ix = FILE *

   push hl                     ; save length
   ld a,STDIO_MSG_WRIT
   call l_jpix                 ; write buffer
   pop de                      ; de = original length
   jp c, stdio_error_mc
   
   sbc hl,de                   ; amount of buffer not written
   jp z, stdio_success_znc
   jp stdio_error_mc

defc ASMDISP_FPUTS_CALLEE = asmentry - fputs_callee
