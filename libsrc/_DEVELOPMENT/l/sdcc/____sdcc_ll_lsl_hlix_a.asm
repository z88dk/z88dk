
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_lsl_hlix_a

EXTERN l_lsl_dehldehl
EXTERN l_load_64_dehldehl_mbc, l_store_64_dehldehl_mbc

____sdcc_ll_lsl_hlix_a:

   push ix
   pop bc
   
   add hl,bc
   
   ld c,l
   ld b,h
   
   push bc
   
   ex af,af'
   call l_load_64_dehldehl_mbc
   ex af,af'
   
   call l_lsl_dehldehl
   
   pop bc
   jp l_store_64_dehldehl_mbc
