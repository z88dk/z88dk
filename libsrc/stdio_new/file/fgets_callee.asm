; char __CALLEE__ *fgets(char *s, int n, FILE *stream)
; 06.2008 aralbrec

PUBLIC fgets_callee
PUBLIC ASMDISP_FGETS_CALLEE

EXTERN fgetc, l_jpix
EXTERN stdio_error_einval_zc, stdio_error_zc
EXTERN ASMDISP_FGETC

INCLUDE "../stdio.def"

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
   ; uses  : af, bc, de, hl, ix, exx
   
   ld a,b
   or c
   jp z, stdio_error_einval_zc

   push hl                     ; save string address

   dec bc                      ; ensure there is room for terminating NUL
   ld a,b
   or c
   jr z, success
   
   exx
   call fgetc + ASMDISP_FGETC  ; use fgetc to grab possible unget char
   exx
   jp c, stdio_error_zc - 1
 
.loop

   or a                        ; avoid NULs causing trouble
   jr z, success

   ld (hl),a                   ; write stream char into string
   inc hl
   dec bc

   cp 13                       ; stop if end of line seen
   jr z, success

   ld a,b                      ; reached max string length?
   or c
   jr z, success

   exx
   ld a,STDIO_MSG_GETC
   call l_jpix
   exx
   
   jp nc, loop
   ccf

.success

   ld (hl),0                   ; terminate string with '\0'
   
   pop hl                      ; return char *s
   ret
   
defc ASMDISP_FGETS_CALLEE = # asmentry - fgets_callee
