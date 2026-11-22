
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_copy_src_de_dst_hlix

____sdcc_ll_copy_src_de_dst_hlix:

IFDEF __SDCC_IX

   push ix
   pop bc
   
ELSE

   push iy
   pop bc
   
ENDIF
   
   add hl,bc
   ex de,hl
   
   ld bc,8
   ldir

   ret
