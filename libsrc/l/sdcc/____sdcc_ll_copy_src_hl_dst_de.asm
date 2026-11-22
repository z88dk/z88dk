
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_copy_src_hl_dst_de

____sdcc_ll_copy_src_hl_dst_de:

   ld bc,8
   ldir
   
   ret
