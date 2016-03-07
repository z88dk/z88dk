; void __CALLEE__ *memchr_callee(char *s, char c, uint n)
; return ptr to first occurence of c in s
; 12.1999 djm, 12.2006 aralbrec

SECTION code_clib
PUBLIC memchr_callee
PUBLIC _memchr_callee
PUBLIC ASMDISP_MEMCHR_CALLEE
EXTERN     rcmx_cpir


.memchr_callee
._memchr_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   ; enter : hl = char *s
   ;          a = char c
   ;         bc = uint n
   ; exit  : found: hl = ptr to c in s, Z flag set
   ;         else : hl = 0, NZ flag set
   ; uses  : f, bc, hl
   
.asmentry
   
   ld a,e
   cpir
   dec hl
   ret z
   
   ld h,b
   ld l,c
   ret
   
DEFC ASMDISP_MEMCHR_CALLEE = # asmentry - memchr_callee
