; void __FASTCALL__ rewind(FILE *stream)
; 06.2008 aralbrec

XLIB rewind

INCLUDE "stdio.def"

.rewind

   push hl
   pop ix                      ; ix = FILE *stream
   
   res 0,(ix+3)                ; no unget char
   
   ld b,3                      ; set file position
   ld c,STDIO_MSG_SEEK
   ld hl,0
   ld e,l
   ld d,h                      ; new pos = 0L
   
   jp (ix)
