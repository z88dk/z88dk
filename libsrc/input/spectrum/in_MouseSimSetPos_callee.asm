; void __CALLEE__ in_MouseSimSetPos_callee(struct in_UDM *u, uint xcoord, uint ycoord)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_MouseSimSetPos_callee
PUBLIC _in_MouseSimSetPos_callee
PUBLIC ASMDISP_IN_MOUSESIMSETPOS_CALLEE

EXTERN l_setmem

.in_MouseSimSetPos_callee
._in_MouseSimSetPos_callee

   pop hl
   pop bc
   ld b,c
   pop de
   ld c,e
   ex (sp),hl

.asmentry

; enter: C = x coord 0..255
;        B = y coord 0..191
;        HL = struct in_UDM *

   ld de,6
   add hl,de
   xor a
   call l_setmem-5
   inc hl
   ld (hl),b
   inc hl
   ld (hl),a
   inc hl
   ld (hl),c
   ret

DEFC ASMDISP_IN_MOUSESIMSETPOS_CALLEE = # asmentry - in_MouseSimSetPos_callee
