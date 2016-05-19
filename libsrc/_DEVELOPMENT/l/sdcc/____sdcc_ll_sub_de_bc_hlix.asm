
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_sub_de_bc_hlix

EXTERN ____sdcc_ll_sub_de_bc_hl

____sdcc_ll_sub_de_bc_hlix:

   push bc
   
   push ix
   pop bc
   
   add hl,bc
   
   pop bc
   
   jp ____sdcc_ll_sub_de_bc_hl
