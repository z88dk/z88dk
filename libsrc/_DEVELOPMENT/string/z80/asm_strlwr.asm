
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strlwr(char *s)
;
; Change letters in string s to lowercase.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strlwr

EXTERN asm_tolower

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
   jr loop

exit:

   pop hl
   ret
