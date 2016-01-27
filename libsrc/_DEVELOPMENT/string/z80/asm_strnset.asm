
; ===============================================================
; Jan 2015
; ===============================================================
; 
; char *strnset(char *s, int c, size_t n)
;
; Write at most n chars c into s.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strnset

asm_strnset:

   ; enter : hl = char *s
   ;          e = int c
   ;         bc = size_t n
   ;
   ; exit  : hl = char *s
   ;         bc = remaining n
   ;
   ; uses  : af, bc
   
   ld a,b
   or c
   ret z
   
   push hl
   xor a
   
loop:

   cp (hl)
   jr z, exit
   
   ld (hl),e
   
   cpi                         ; hl++, bc--
   jp pe, loop

exit:

   pop hl
   ret
