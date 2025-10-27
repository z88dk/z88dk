
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_lsr_hlix_a
PUBLIC ____sdcc_ll_lsr_hlix_a_0

EXTERN l_lsr_dehldehl
EXTERN l_load_64_dehldehl_mbc, l_store_64_dehldehl_mbc

____sdcc_ll_lsr_hlix_a:

IFDEF __SDCC_IX

   push ix
   pop bc
   
ELSE

   push iy
   pop bc
   
ENDIF
   
   add hl,bc
   
   ld c,l
   ld b,h

____sdcc_ll_lsr_hlix_a_0:

   push bc
   
   ex af,af'
   call l_load_64_dehldehl_mbc
   ex af,af'
   
   call l_lsr_dehldehl
   
   pop bc
   jp l_store_64_dehldehl_mbc
