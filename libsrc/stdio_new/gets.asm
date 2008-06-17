; char __FASTCALL__ *gets(char *s)
; 06.2008 aralbrec

XLIB gets
LIB fgetc, l_jpix, stdio_error_zc
XREF ASMDISP_FGETC, _stdin

INCLUDE "stdio.def"

; gets() is different enough from fgets() that we
; have to write an independent function.... grrrr

.gets

   ; enter : hl = char *s
   ; exit  : hl = char *s and no carry for success
   ;         hl = 0 and carry for fail
   ; uses  : af, bc, de, hl, ix

   push hl
   ld ix,(_stdin)
   call fgetc + ASMDISP_FGETC  ; fgetc handles the unget char for us
   ld a,l
   pop hl
   jp c, stdio_error_zc

   push hl                     ; char *s on stack   
   
.loop

   or a                        ; avoid NULs causing trouble
   jr z, success

   cp 13                       ; stop if end of line seen
   jr z, success
   
   ld (hl),a                   ; write stream char into string
   inc hl
   
   push hl
   ld c,STDIO_MSG_GETC
   call l_jpix
   pop hl
   
   jp nc, loop
   ccf
   
.success

   ld (hl),0                   ; terminate string with '\0'
   pop hl                      ; return char *s
   ret
