
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_copy_src_de_dst_hlsp

____sdcc_ll_copy_src_de_dst_hlsp:

   add hl,sp
   ex de,hl
   ld bc,8
   ldir
   ret
