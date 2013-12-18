
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *memcpy(void * restrict s1, const void * restrict s2, size_t n)
;
; Copy n chars from s2 to s1, return s1.
;
; ===============================================================

XLIB asm_memcpy
XDEF asm0_memcpy, asm1_memcpy

asm_memcpy:

   ; enter : bc = size_t n
   ;         hl = void *s2 = src
   ;         de = void *s1 = dst
   ;
   ; exit  : hl = void *s1 = dst
   ;         de = ptr in s1 to one byte past last byte copied
   ;         bc = 0
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl

   ld a,b
   or c
   jr z, zero_n

asm0_memcpy:

   push de
   ldir
   pop hl
   
   ret

asm1_memcpy:
zero_n:

   ld l,e
   ld h,d
   
   ret
