; char __CALLEE__ *strpbrk_callee(char *s, char *match)
; return ptr to first occurrence in s1 of any char in match
; 01.2007 aralbrec

SECTION code_clib
PUBLIC strpbrk_callee
PUBLIC _strpbrk_callee
PUBLIC ASMDISP_STRPBRK_CALLEE

EXTERN strchr_callee
EXTERN ASMDISP_STRCHR_CALLEE

.strpbrk_callee
._strpbrk_callee

   pop hl
   pop de
   ex (sp),hl
   
   ; enter : hl = char *s
   ;         de = char *match
   ; exit  : found : hl = ptr, NC flag set
   ;         else  : hl = 0, C flag set
   ; uses  : af, c, hl
   
.asmentry
.loop

   ld a,(hl)
   or a
   jr z, fail

   push hl
   ld l,e
   ld h,d
   ld c,a
   call strchr_callee + ASMDISP_STRCHR_CALLEE
   pop hl
   ret nc
   
   inc hl
   jp loop

.fail

   ld l,a
   ld h,a
   scf
   ret

DEFC ASMDISP_STRPBRK_CALLEE = # asmentry - strpbrk_callee
