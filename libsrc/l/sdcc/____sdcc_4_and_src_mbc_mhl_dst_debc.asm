SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_and_src_mbc_mhl_dst_debc

____sdcc_4_and_src_mbc_mhl_dst_debc:

   ld a,(bc)
   and (hl)
   ld e,a
   inc bc
   inc hl
   
   ld a,(bc)
   and (hl)
   ld d,a
   inc bc
   inc hl
   
   push de
   
   ld a,(bc)
   and (hl)
   ld e,a
   inc bc
   inc hl
   
   ld a,(bc)
   and (hl)
   ld d,a

   pop bc
   ret
