; char __FASTCALL__ *gets(char *s)
; 06.2008 aralbrec

XLIB gets
LIB fgetc, l_jpix
XREF _stdin, ASMDISP_FGETC

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
   jr c, fail

   push hl                     ; char *s on stack   
   
.loop

   cp 10                       ; deal with '\r\n' by ignoring '\r'
   jr z, ignore

   or a                        ; avoid dropping stream chars
   jr z, success
   
   cp 13                       ; stop if end of line seen
   jr z, success
   
   ld (hl),a                   ; write stream char into string
   inc hl
   
.ignore

   push hl
   ld c,STDIO_SERVICE_GETCHAR
   call l_jpix
   pop hl
   
   jp nc, loop
   ccf
   
.success

   ld (hl),0                   ; terminate string with '\0'
   pop hl                      ; return char *s
   ret

.fail

   ld hl,0
   ret
