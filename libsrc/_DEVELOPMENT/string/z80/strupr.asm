
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strupr(char *s)
;
; Change letters in string s to uppercase.
;
; ===============================================================

XLIB strupr
XDEF asm_strupr

LIB asm_toupper

strupr:
asm_strupr:

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

   call asm_toupper
   ld (hl),a
   
   inc hl
   jp loop

exit:

   pop hl
   ret
