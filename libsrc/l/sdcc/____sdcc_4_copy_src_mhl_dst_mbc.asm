
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_copy_src_mhl_dst_mbc

____sdcc_4_copy_src_mhl_dst_mbc:

   ld a,(hl)
   ld (bc),a
   inc bc
   inc hl
   ld a,(hl)
   ld (bc),a
   inc bc
   inc hl
   ld a,(hl)
   ld (bc),a
   inc bc
   inc hl
   ld a,(hl)
   ld (bc),a

   ret
