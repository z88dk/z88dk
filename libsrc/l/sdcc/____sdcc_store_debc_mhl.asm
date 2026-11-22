
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_store_debc_mhl

____sdcc_store_debc_mhl:

   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d
   
   ret
