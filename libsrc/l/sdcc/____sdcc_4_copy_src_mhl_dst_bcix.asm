
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_copy_src_mhl_dst_bcix

EXTERN ____sdcc_4_copy_src_mhl_dst_deix

____sdcc_4_copy_src_mhl_dst_bcix:
   
   push de
   
   ld e,c
   ld d,b
   
   call ____sdcc_4_copy_src_mhl_dst_deix
   
   pop de
   ret
