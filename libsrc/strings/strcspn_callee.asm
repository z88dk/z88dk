; int __CALLEE__ strcspn_callee(char *s1, char *s2)
; return length of prefix of s1 NOT containing chars in s2
; 01.2007 aralbrec

SECTION code_clib
PUBLIC strcspn_callee
PUBLIC _strcspn_callee
PUBLIC ASMDISP_STRCSPN_CALLEE

EXTERN strchr_callee
EXTERN ASMDISP_STRCHR_CALLEE

.strcspn_callee
._strcspn_callee

   pop hl
   pop de
   ex (sp),hl
   
   ; enter : de = char *s2
   ;         hl = char *s1
   ; exit  : hl = prefix length
   ; uses  : af, bc, hl

.asmentry

   ld bc,0                   ; counter
   
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
   jr nc, done
   inc bc
   inc hl
   jp loop

.done

   ld l,c
   ld h,b
   ret

DEFC ASMDISP_STRCSPN_CALLEE = # asmentry - strcspn_callee
