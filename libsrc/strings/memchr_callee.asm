; void __CALLEE__ *memchr_callee(char *s, char c, uint n)
; return ptr to first occurence of c in s
; 12.1999 djm, 12.2006 aralbrec

XLIB memchr_callee
XDEF ASMDISP_MEMCHR_CALLEE

.memchr_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl
   ld a,e
   
   ; enter : hl = char *s
   ;          a = char c
   ;         bc = uint n
   ; exit  : found: hl = ptr to c in s, Z flag set
   ;         else : hl = 0, NZ flag set
   ; uses  : f, bc, hl
   
.asmentry
   
   cpir
   dec hl
   ret z
   
   ld h,b
   ld l,c
   ret
   
DEFC ASMDISP_MEMCHR_CALLEE = asmentry - memchr_callee
