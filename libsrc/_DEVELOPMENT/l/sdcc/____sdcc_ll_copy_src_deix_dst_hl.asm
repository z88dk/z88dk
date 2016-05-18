
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_copy_src_deix_dst_hl

____sdcc_ll_copy_src_deix_dst_hl:

   push hl
   
   push ix
   pop hl
   
   add hl,de
   
   pop de
   
   ld bc,8
   ldir

   ret
