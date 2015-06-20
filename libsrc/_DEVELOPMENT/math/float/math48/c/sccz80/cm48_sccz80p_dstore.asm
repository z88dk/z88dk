
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dstore

cm48_sccz80p_dstore:

   ; sccz80 float primitive
   ; Write float in AC' to memory pointed at by HL.
   ;
   ; Convert from math48 format to sccz80 format.
   ;
   ; enter :         HL   = double * (sccz80 format)
   ;         AC'(BCDEHL') = double (math48 format)
   ;
   ; uses  : A

   push hl
   
   exx
   
   ld a,h
   ex (sp),hl
   
   ld (hl),a
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   
   ex de,hl
   ex (sp),hl
   
   ld a,l
   ld (de),a
   
   pop de
   
   exx
   ret
