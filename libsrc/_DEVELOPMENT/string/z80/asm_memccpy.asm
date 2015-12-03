
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *memccpy(void * restrict s1, const void * restrict s2, int c, size_t n)
;
; Copy n chars from s2 to s1, stopping early the first time
; char c is copied.
;
; Return NULL if char c not encountered or ptr to byte after
; char c in s1.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_memccpy

EXTERN error_zc

asm_memccpy:

   ; enter : hl = void *s2 = src
   ;         de = void *s1 = dst
   ;         bc = size_t n
   ;          a = char c
   ;
   ; exit  :  a = char c
   ;         de = ptr in dst following last char copied  
   ; 
   ;         char c found
   ;
   ;            carry reset, z flag set
   ;            hl = ptr in dst to char following copied char c
   ;
   ;         char c not found
   ;
   ;            carry set, z flag set if n == 0
   ;            hl = 0
   ;            bc = 0
   ;
   ; uses  : f, bc, de, hl
   
   inc c
   dec c
   jr z, test0

loop:

   cp (hl)
   ldi
   jr z, match
   jp pe, loop

nomatch:

   jp error_zc

match:

   ld l,e
   ld h,d                      ; hl = ptr in dst to char following char c
   ret                         ; z flag set

test0:

   inc b
   djnz loop
   
   jr nomatch
