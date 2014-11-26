; void sp1_PutSprClr(uchar **sprdest, struct sp1_ap *src, uchar n)
; CALLER linkage for function pointers

SECTION seg_code_sp1

PUBLIC sp1_PutSprClr

EXTERN asm_sp1_PutSprClr

sp1_PutSprClr:

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   ld b,c
   
   jp asm_sp1_PutSprClr
