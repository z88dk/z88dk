SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_or_src_debc_mhl_dst_debc

____sdcc_4_or_src_debc_mhl_dst_debc:

   ld a,(hl)
   or c
   ld c,a
   inc hl
   ld a,(hl)
   or b
   ld b,a
   inc hl
   ld a,(hl)
   or e
   ld e,a
   inc hl
   ld a,(hl)
   or d
   ld d,a
   
   ret
