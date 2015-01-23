; int __CALLEE__ fputc(int c, FILE *stream)
; 06.2008 aralbrec

PUBLIC fputc_callee
PUBLIC ASMDISP_FPUTC_CALLEE

EXTERN l_jpix, stdio_error_mc, stdio_error_eacces_mc

INCLUDE "../stdio.def"

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
   
   bit 1,(ix+3)                ; open for output?
   jp z, stdio_error_eacces_mc
   
   push hl                     ; save char
   ld c,l
   ld a,STDIO_MSG_PUTC
   call l_jpix
   pop hl
   jp c, stdio_error_mc
   
   ld h,0                      ; hl = char
   ret

defc ASMDISP_FPUTC_CALLEE = # asmentry - fputc_callee
