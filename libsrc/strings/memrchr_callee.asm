; void __CALLEE__ *memrchr_callee(char *s, char c, uint n)
; return ptr to last occurence of c in s (reverse search)
; 12.1999 djm, 12.2006 aralbrec, 04.2012 stefano

XLIB memrchr_callee
XDEF ASMDISP_MEMRCHR_CALLEE
LIB     rcmx_cpdr


.memrchr_callee

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
   add hl,bc
   cpdr
   dec hl
   ret z
   
   ld h,b
   ld l,c
   ret
   
DEFC ASMDISP_MEMRCHR_CALLEE = asmentry - memrchr_callee
