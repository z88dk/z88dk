
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dstore

am48_dstore:

   ; store AC' to memory
   ;
   ; enter : hl = double *
   ;
   ; exit  : AC' written to address HL
   ;
   ; uses  : none
   
   push hl
   
   exx
   
   ex de,hl
   ex (sp),hl
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   ex (sp),hl
   ex de,hl
   ex (sp),hl
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   ld (hl),c
   inc hl
   ld (hl),b
   
   pop hl
   
   exx
   ret
