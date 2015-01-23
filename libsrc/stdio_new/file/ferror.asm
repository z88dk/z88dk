; int __FASTCALL__ ferror(FILE *stream)
; 06.2008 aralbrec

PUBLIC ferror
EXTERN l_jphl

INCLUDE "../stdio.def"

.ferror

   push hl
   pop ix

   ld a,STDIO_MSG_FERR
   call l_jphl
   
   ld h,0
   ld l,a
   
   bit 0,(ix+3)                ; unget char available?
   ret z                       ; if no return
   
   and $7f                     ; otherwise its not eof
   ld l,a                      ; ensure A as well as HL contain error bits
   ret
