; int __CALLEE__ strspn_callee(char *s1, char *s2)
; return length of prefix in s1 containing chars in s2
; 01.2007 aralbrec

SECTION code_clib
PUBLIC strspn_callee
PUBLIC _strspn_callee
PUBLIC ASMDISP_STRSPN_CALLEE

EXTERN strchr_callee
EXTERN ASMDISP_STRCHR_CALLEE

.strspn_callee
._strspn_callee

   pop hl
   pop de
   ex (sp),hl
   
   ; enter : de = char *s2
   ;         hl = char *s1
   ; exit  : hl = prefix length
   ; uses  : af, bc, hl

.asmentry
   
   ld bc,0
   
.loop

   ld a,(hl)
   or a
   jr z, done
   
   push bc
   push hl
   ld c,a
   ld l,e
   ld h,d
   call strchr_callee + ASMDISP_STRCHR_CALLEE
   pop hl
   pop bc
   jr c, done
   inc bc
   inc hl
   jp loop

.done

   ld l,c
   ld h,b
   ret

DEFC ASMDISP_STRSPN_CALLEE = # asmentry - strspn_callee
