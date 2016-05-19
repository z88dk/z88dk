
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_sub_hlix_deix_bc

EXTERN ____sdcc_ll_sub_de_bc_hl

____sdcc_ll_sub_hlix_deix_bc:

   push bc
   
   push ix
   pop bc
   
   add hl,bc
   ex de,hl
   
   add hl,bc
   ex (sp),hl
   
   pop bc
   
   jp ____sdcc_ll_sub_de_bc_hl
