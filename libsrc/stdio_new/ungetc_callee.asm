; int __CALLEE__ ungetc(int c, FILE *stream)
; 06.2008 aralbrec

XLIB ungetc_callee
XDEF ASMDISP_UNGETC_CALLEE
LIB stdio_error

.ungetc_callee

   pop hl
   pop ix
   ex (sp),hl

.asmentry

   ; enter : ix = FILE *stream
   ;         hl = int c
   ; exit  : hl = char c and carry reset for success
   ;         hl = -1 and carry set for fail
   ; uses  : af, hl, ix
   
   bit 7,(ix+3)                ; valid FILE *?
   jp z, stdio_error
   
   ld a,h                      ; allowing pushback EOF would be bad
   and l
   inc a
   jp z, stdio_error
   
   set 0,(ix+3)                ; indicate unget char available
   ld (ix+4),l                 ; store unget char
   
   ld h,0
   or a
   ret

defc ASMDISP_UNGETC_CALLEE = asmentry - ungetc_callee
