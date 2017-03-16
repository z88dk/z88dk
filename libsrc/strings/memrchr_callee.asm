; void __CALLEE__ *memrchr_callee(char *s, char c, uint n)
; return ptr to last occurence of c in s (reverse search)
; 12.1999 djm, 12.2006 aralbrec, 04.2012 stefano

SECTION code_clib
PUBLIC memrchr_callee
PUBLIC _memrchr_callee
PUBLIC ASMDISP_MEMRCHR_CALLEE
EXTERN     rcmx_cpdr


.memrchr_callee
._memrchr_callee

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
   add hl,bc
   dec hl
   cpdr
   inc hl
   ret z
   
   ld h,b
   ld l,c
   ret
   
DEFC ASMDISP_MEMRCHR_CALLEE = # asmentry - memrchr_callee
