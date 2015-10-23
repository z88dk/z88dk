
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *memset(void *s, int c, size_t n)
;
; Write c into the first n bytes of s.
;
; ===============================================================

SECTION code_string

PUBLIC asm_memset

EXTERN l_fast_memcpy

asm_memset:

   ; enter : hl = void *s
   ;          e = char c
   ;         bc = uint n
   ;
   ; exit  : hl = void *s
   ;         de = ptr in s to byte after last one written
   ;         bc = 0
   ;         carry reset
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

   ld a,c
   and $e0
   or b
   jr z, slow_memset

fast_memset:

   push hl
   
   call l_fast_memcpy
   
   pop hl
   ret

slow_memset:

   or c
   ret z

   push hl
   
   ldir
   
   pop hl
   ret
