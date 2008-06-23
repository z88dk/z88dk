; long __FASTCALL__ ftell(FILE *stream)
; 06.2008 aralbrec

XLIB ftell
LIB stdio_error_mc, l_declong, l_jpix

INCLUDE "stdio.def"

.ftell

   push hl
   pop ix                      ; ix = FILE *
   
   ld hl,0
   ld e,l
   ld d,h                      ; relative seek by 0 bytes
   
   ld b,2                      ; seek from current position
   ld c,STDIO_MSG_SEEK
   call l_jpix
   jr c, error

   bit 0,(ix+3)                ; if an unget char is pending
   jp nz, l_declong            ;  decrement file position
   
   ret

.error

   call stdio_error_mc
   ld e,l
   ld d,h
   
   ret
