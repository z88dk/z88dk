
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_load_hlde_mhl

____sdcc_load_hlde_mhl:

   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   ret
