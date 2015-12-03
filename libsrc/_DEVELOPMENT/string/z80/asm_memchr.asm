
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *memchr(const void *s, int c, size_t n)
;
; Return ptr to first occurrence of c among the first n chars of s.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_memchr
PUBLIC asm0_memchr

EXTERN error_zc

asm_memchr:

   ; enter :  a = char c
   ;         hl = char *s
   ;         bc = size_t n
   ;
   ; exit  : a = char c
   ;
   ;         char found
   ;
   ;            carry reset
   ;            hl = ptr to c
   ;
   ;         char not found
   ;
   ;            carry set
   ;            z flag set if n == 0
   ;            bc = 0
   ;            hl = 0
   ;
   ; uses  : f, bc, hl

   inc c
   dec c
   jr z, test0

asm0_memchr:
loop:

   cpir
   dec hl
   ret z                       ; char found

notfound:

   jp error_zc

test0:

   inc b
   djnz loop

   jr notfound
