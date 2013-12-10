
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strlwr(char *s)
;
; Change letters in string s to lowercase.
;
; ===============================================================

XLIB strlwr
XDEF asm_strlwr

LIB asm_tolower

strlwr:
asm_strlwr:

   ; enter: hl = char *s
   ;
   ; exit : hl = char *s
   ;
   ; uses : af

   push hl

loop:

   ld a,(hl)
   or a
   jr z, exit

   call asm_tolower
   ld (hl),a
   
   inc hl
   jp loop

exit:

   pop hl
   ret
