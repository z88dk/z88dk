; int __CALLEE__ strpos_callee(char *s, char c)
; find index of first occurrence of c in s
; 01.2007 aralbrec

SECTION code_clib
PUBLIC strpos_callee
PUBLIC _strpos_callee
PUBLIC ASMDISP_STRPOS_CALLEE

.strpos_callee
._strpos_callee

   pop hl
   pop de
   pop bc
   push hl
   
   ; enter :  e = char c
   ;         bc = char *s
   ; exit  : found : hl = index of char c, NC flag set
   ;         else  : hl = -1, C flag set
   ; uses  : af, bc, hl
   
.asmentry

   ld hl,0
   
.loop

   ld a,(bc)
   cp e                      ; putting this first allows
   ret z                     ;  search for '\0'
   
   or a
   jr z, fail

   inc bc
   inc hl
   jp loop


.fail

   dec a
   ld l,a
   ld h,a
   scf
   ret

DEFC ASMDISP_STRPOS_CALLEE = # asmentry - strpos_callee
