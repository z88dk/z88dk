; uint __CALLEE__ fread_callee(void *p, uint size, uint nitems, FILE *stream)
; 06.2008 aralbrec

XLIB fread_callee
XDEF ASMDISP_FREAD_CALLEE
LIB fgetc, l_mult, l_div_u, l_jpix, stdio_error_mc, stdio_success_znc

include "stdio.def"

.fread_callee

   pop af
   pop ix
   pop hl
   pop de
   pop bc
   push af

.asmentry

   ; enter : ix = FILE *stream
   ;         hl = uint nitems
   ;         de = uint size
   ;         bc = void *p
   ; exit  : hl = number items read, carry reset for success
   ;         hl = -1 and carry set for problem on stream (0 bytes read)
   
   push de                     ; save size
   push bc                     ; save void*

   call l_mult                 ; hl = nitems * size
   ld a,h
   or l
   jp z, stdio_success_znc - 2

   push hl
   call fgetc + ASMDISP_FGETC  ; check stream for input, get unget char
   ld a,l                      ; a = char
   pop hl
   pop de                      ; de = void*
   jp c, stdio_error_mc - 1

   ld (de),a                   ; write char to buffer
   inc de
   
   dec hl
   ld a,h
   or l
   jr z, onesize

   ld c,STDIO_MSG_READ
   call l_jpix
   inc hl                      ; one more byte actually read by fgetc call above
   pop de                      ; de = size

   ex de,hl                    ; hl = size, de = number bytes read
   call l_div_u                ; hl = numbytes / size
   
   or a
   ret

.onesize

   inc hl
   pop bc
   ret

defc ASMDISP_FREAD_CALLEE = asmentry - fread_callee
