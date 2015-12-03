
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t strlen(const char *s)
;
; Return length of string s.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strlen

asm_strlen:

   ; enter: hl = char *s
   ;
   ; exit : hl = length
   ;        bc = -(length + 1)
   ;         a = 0
   ;        z flag set if 0 length
   ;        carry reset
   ;
   ; uses : af, bc, hl

   xor a
   ld c,a
   ld b,a
   
   cpir
   
   ld hl,$ffff
   sbc hl,bc

   ret
