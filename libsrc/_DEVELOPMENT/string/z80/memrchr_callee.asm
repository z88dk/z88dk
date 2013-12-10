
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *memrchr(const void *s, int c, size_t n)
;
; Return ptr to last occurrence of c among the first n chars of s.
;
; ===============================================================

XLIB memrchr_callee
XDEF asm_memrchr, asm0_memrchr

memrchr_callee:

   pop hl
   pop bc
   pop de
   ld a,e
   ex (sp),hl

asm_memrchr:

   ; enter :  a = char c
   ;         hl = char *s
   ;         bc = size_t n
   ;
   ; exit  : 
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

   ld l,c
   ld h,b
   
   scf
   ret

test0:

   inc b
   djnz loop
   
   jr notfound
