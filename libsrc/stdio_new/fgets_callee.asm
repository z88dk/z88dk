; char __CALLEE__ *fgets(char *s, int n, FILE *stream)
; 06.2008 aralbrec

XLIB fgets_callee
XDEF ASMDISP_FGETS_CALLEE

LIB fgetc, l_jpix
XREF ASMDISP_FGETC

INCLUDE "stdio.def"

.fgets_callee

   pop hl
   pop ix
   pop bc
   ex (sp),hl

.asmentry

   ; enter : bc = int n
   ;         hl = char *s
   ;         ix = FILE *stream
   ; exit  : hl = char *s and no carry for success
   ;         hl = 0 and carry for fail
   ; uses  : af, bc, de, hl, ix
   
   bit 2,(ix+3)                ; open for input?
   jr z, fail1
   
   ld a,b
   or c
   jr z, fail1

   push hl                     ; save string address

   dec bc
   ld a,b
   or c
   jr z, success
   
   push bc
   push hl
   call fgetc + ASMDISP_FGETC  ; use fgetc to grab possible unget char
   ld a,l
   pop hl
   pop bc
   jr c, fail0
   
.loop

   or a                        ; avoid dropping stream chars
   jr z, success

   ld (hl),a                   ; write stream char into string
   inc hl
   dec bc

   cp 13                       ; stop if end of line seen
   jr z, success

   ld a,b                      ; reached max string length?
   or c
   jr z, success

   push bc
   push hl
   ld c,STDIO_MSG_GETC
   call l_jpix
   pop hl
   pop bc
   
   jp nc, loop
   ccf

.success

   ld (hl),0                   ; terminate string with '\0'
   pop hl                      ; return char *s
   ret
   
.fail0

   pop de                      ; pop string address

.fail1

   ld hl,0
   scf
   ret
   
defc ASMDISP_FGETS_CALLEE = asmentry - fgets_callee
