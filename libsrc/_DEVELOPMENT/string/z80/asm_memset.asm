
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *memset(void *s, int c, size_t n)
;
; Write c into the first n bytes of s.
;
; ===============================================================

XLIB asm_memset

asm_memset:

   ; enter : hl = void *s
   ;          e = char c
   ;         bc = uint n
   ;
   ; exit  : hl = void *s
   ;         de = ptr in s to byte after last one written
   ;         bc = 0
   ;
   ; uses  : af, bc, de

   ld a,b
   or c

   ld a,e
   ld e,l
   ld d,h

   ret z

   ld (hl),a
   inc de
   
   dec bc
   ld a,b
   or c
   ret z

   push hl
   ldir
   pop hl

   ret
