; void *sp1_PreShiftSpr(uchar flag, uchar height, uchar width, void *srcframe, void *destframe, uchar rshift)
; CALLER linkage for function pointers

PUBLIC sp1_PreShiftSpr

EXTERN sp1_PreShiftSpr_callee
EXTERN ASMDISP_SP1_PRESHIFTSPR_CALLEE

.sp1_PreShiftSpr

   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld iyl,e
   ld iyh,d
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld b,(hl)
   inc hl
   inc hl
   ld a,(hl)
   inc hl
   inc hl
   ld h,(hl)
   ld l,a
   ld a,c
   jp sp1_PreShiftSpr_callee + ASMDISP_SP1_PRESHIFTSPR_CALLEE
