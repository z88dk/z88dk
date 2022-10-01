; void sp1_PutSprClr(uchar **sprdest, struct sp1_ap *src, uchar n)
; CALLER linkage for function pointers

SECTION code_sprite_sp1
PUBLIC sp1_PutSprClr

EXTERN sp1_PutSprClr_callee
EXTERN ASMDISP_SP1_PUTSPRCLR_CALLEE

.sp1_PutSprClr

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   ld b,c
   jp sp1_PutSprClr_callee + ASMDISP_SP1_PUTSPRCLR_CALLEE
