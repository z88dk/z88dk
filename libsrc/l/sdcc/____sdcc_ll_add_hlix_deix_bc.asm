
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_add_hlix_deix_bc

EXTERN ____sdcc_ll_add_de_bc_hl

____sdcc_ll_add_hlix_deix_bc:

   push bc
   
IFDEF __SDCC_IX

   push ix
   pop bc

ELSE

   push iy
   pop bc

ENDIF
   
   add hl,bc
   ex de,hl
   
   add hl,bc
   ex (sp),hl
   
   pop bc
   
   jp ____sdcc_ll_add_de_bc_hl
