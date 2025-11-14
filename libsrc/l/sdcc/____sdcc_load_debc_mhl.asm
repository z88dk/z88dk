
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_load_debc_mhl

____sdcc_load_debc_mhl:

   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)

   ret
