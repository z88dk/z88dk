SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_xor_src_debc_mhl_dst_debc

____sdcc_4_xor_src_debc_mhl_dst_debc:

   ld a,(hl)
   xor c
   ld c,a
   inc hl
   ld a,(hl)
   xor b
   ld b,a
   inc hl
   ld a,(hl)
   xor e
   ld e,a
   inc hl
   ld a,(hl)
   xor d
   ld d,a
   
   ret
