
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_copy_src_hlsp_dst_de

____sdcc_ll_copy_src_hlsp_dst_de:

   add hl,sp
   ld bc,8
   ldir
   ret
