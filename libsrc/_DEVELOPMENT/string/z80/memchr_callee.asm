
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *memchr(const void *s, int c, size_t n)
;
; Return ptr to first occurrence of c among the first n chars of s.
;
; ===============================================================

XLIB memchr_callee
XDEF asm_memchr, asm0_memchr

memchr_callee:

   pop hl
   pop bc
   pop de
   ld a,e
   ex (sp),hl

asm_memchr:

   ; enter :  a = char c
   ;         hl = char *s
   ;         bc = size_t n
   ;
   ; exit  : 
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

   ld l,c
   ld h,b
   
   scf
   ret

test0:

   inc b
   djnz loop

   jr notfound
