SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_and_src_debc_mhl_dst_debc

____sdcc_4_and_src_debc_mhl_dst_debc:

   ld a,(hl)
   and c
   ld c,a
   inc hl
   ld a,(hl)
   and b
   ld b,a
   inc hl
   ld a,(hl)
   and e
   ld e,a
   inc hl
   ld a,(hl)
   and d
   ld d,a
   
   ret
