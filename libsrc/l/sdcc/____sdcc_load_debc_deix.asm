
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_load_debc_deix

____sdcc_load_debc_deix:

IFDEF __SDCC_IX
   
   push ix
   
ELSE

   push iy

ENDIF

   ex (sp),hl
   add hl,de

   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   
   pop hl
   ret
