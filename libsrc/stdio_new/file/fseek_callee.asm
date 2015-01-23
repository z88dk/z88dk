; int __CALLEE__ fseek_callee(FILE *stream, long offset, int whence)
; 06.2008 aralbrec

PUBLIC fseek_callee
PUBLIC ASMDISP_FSEEK_CALLEE

EXTERN stdio_success_znc, stdio_error_mc, l_jpix, l_declong

INCLUDE "../stdio.def"

.fseek_callee

   pop af
   pop bc
   pop hl
   pop de
   pop ix
   push af

.asmentry

   ; enter : dehl = offset
   ;            c = whence
   ;           ix = FILE *stream
   
   ld a,c                      ; if this is a relative seek from current pos
   cp STDIO_SEEK_CUR
   jr nz, seek
   
   bit 0,(ix+3)                ; and an unget char is available
   call nz, l_declong          ; then we need to adjust the seek value by 1
   
.seek
   
   ld a,STDIO_MSG_SEEK
   call l_jpix
   jp c, stdio_error_mc
   
   res 0,(ix+3)                ; clear unget char
   jp stdio_success_znc

defc ASMDISP_FSEEK_CALLEE = # asmentry - fseek_callee
