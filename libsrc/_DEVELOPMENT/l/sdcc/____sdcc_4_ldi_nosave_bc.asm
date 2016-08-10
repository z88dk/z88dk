
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_ldi_nosave_bc

____sdcc_4_ldi_nosave_bc:

   ldi
   ldi
   ldi
   ld   a,(hl)
   ld   (de),a
   
   ret
