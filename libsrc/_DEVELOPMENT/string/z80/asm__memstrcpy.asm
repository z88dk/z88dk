
; ===============================================================
; Jan 2014
; ===============================================================
; 
; char *_memstrcpy(void *p, char *s, size_t n)
;
; At most n chars from string s are copied to p.  The terminating
; '\0' in s is not copied.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm__memstrcpy

asm__memstrcpy:

   ; enter : de = void *p = dst
   ;         hl = char *s = src
   ;         bc = size_n
   ;
   ; exit  : de = void *p_ptr = addr of byte following last write
   ;         hl = char *s_ptr = addr of byte following last read
   ;         bc = n remaining
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl
   
   ld a,b
   or c
   ret z                       ; if n == 0
   
   xor a

loop:

   cp (hl)
   ret z                       ; if '\0' met
   
   ldi
   jp pe, loop

   or a
   ret
