
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *memrchr(const void *s, int c, size_t n)
;
; Return ptr to last occurrence of c among the first n chars of s.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_memrchr
PUBLIC asm0_memrchr

EXTERN error_zc

asm_memrchr:

   ; enter :  a = char c
   ;         hl = char *s
   ;         bc = size_t n
   ;
   ; exit  :  a = char c
   ;
   ;         found
   ;
   ;            carry reset, z flag set
   ;            hl = ptr to c in s
   ;
   ;         not found
   ;
   ;            carry set, z flag set if n == 0
   ;            bc = 0
   ;            hl = 0
   ;
   ; uses  : f, bc, hl

   inc c
   dec c
   jr z, test0

asm0_memrchr:
loop:

   add hl,bc
   dec hl                      ; hl = last byte of block
   
   cpdr   
   inc hl
   ret z                       ; char found

notfound:

   jp error_zc
   
test0:

   inc b
   djnz loop
   
   jr notfound
