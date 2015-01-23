; int __FASTCALL__ feof(FILE *stream)
; 06.2008 aralbrec

PUBLIC feof
EXTERN stdio_error_mc, stdio_success_znc, l_jphl

INCLUDE "../stdio.def"

.feof

   push hl
   pop ix

   bit 0,(ix+3)                ; unget char available?
   jp nz, stdio_success_znc    ; if yes indicate not eof
   
   ld a,STDIO_MSG_FERR
   call l_jphl

   rla
   jp c, stdio_error_mc        ; return eof true
   jp stdio_success_znc
