
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_copy_src_deix_dst_hlix

____sdcc_ll_copy_src_deix_dst_hlix:

   push de

IFDEF __SDCC_IX
   
   push ix
   pop de

ELSE

   push iy
   pop de
   
ENDIF
   
   add hl,de
   ex (sp),hl

   add hl,de

   pop de

   ld bc,8
   ldir

   ret
