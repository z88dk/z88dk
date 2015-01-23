; int __CALLEE__ ungetc(int c, FILE *stream)
; 06.2008 aralbrec

PUBLIC ungetc_callee
PUBLIC ASMDISP_UNGETC_CALLEE
EXTERN stdio_error_eacces_mc, stdio_error_einval_mc

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
   
   bit 2,(ix+3)                ; open for input?
   jp z, stdio_error_eacces_mc
   
   ld a,h                      ; not allowed to pushback EOF
   and l
   inc a
   jp z, stdio_error_einval_mc
  
   ld (ix+4),l                 ; store unget char 
   set 0,(ix+3)                ; indicate unget char available
   
   ld h,0
   ret

defc ASMDISP_UNGETC_CALLEE = # asmentry - ungetc_callee
