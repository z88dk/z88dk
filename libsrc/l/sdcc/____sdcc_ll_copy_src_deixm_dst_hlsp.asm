
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_copy_src_deixm_dst_hlsp

____sdcc_ll_copy_src_deixm_dst_hlsp:

   push hl
   
IFDEF __SDCC_IX
   
   push ix
   pop hl
   
ELSE

   push iy
   pop hl
   
ENDIF
   
   add hl,de
   ld e,(hl)
   inc hl
   ld d,(hl)
   
   pop hl
   
   add hl,sp
   
   ld bc,8
   ex de,hl
   ldir
   ret
