
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_add_deix_bc_hl

EXTERN ____sdcc_ll_add_de_bc_hl

____sdcc_ll_add_deix_bc_hl:

   push hl
   
IFDEF __SDCC_IX

   push ix
   pop hl

ELSE

   push iy
   pop hl
   
ENDIF
   
   add hl,de
   ex de,hl
   
   pop hl

   jp ____sdcc_ll_add_de_bc_hl
