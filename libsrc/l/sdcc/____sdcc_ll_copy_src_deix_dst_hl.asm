
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_copy_src_deix_dst_hl

____sdcc_ll_copy_src_deix_dst_hl:

   push hl
   
IFDEF __SDCC_IX

   push ix
   pop hl

ELSE

   push iy
   pop hl
   
ENDIF
   
   add hl,de
   
   pop de
   
   ld bc,8
   ldir

   ret
