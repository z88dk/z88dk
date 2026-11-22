SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_cpl_src_mhl_dst_debc

____sdcc_4_cpl_src_mhl_dst_debc:

   ld a,(hl)
   cpl
   ld c,a
   inc hl
   ld a,(hl)
   cpl
   ld b,a
   inc hl
   ld a,(hl)
   cpl
   ld e,a
   inc hl
   ld a,(hl)
   cpl
   ld d,a

   ret
