
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_copy_src_hlsp_dst_deixm

____sdcc_ll_copy_src_hlsp_dst_deixm:

   push hl
   
   push ix
   pop hl
   
   add hl,de
   ld e,(hl)
   inc hl
   ld d,(hl)
   
   pop hl
   
   add hl,sp
   
   ld bc,8
   ldir
   ret
