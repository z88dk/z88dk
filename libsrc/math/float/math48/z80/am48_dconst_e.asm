
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dconst_e

am48_dconst_e:

   ; set AC = e
   ;
   ; uses : bc, de, hl

   ld bc,$2df8
   ld de,$5458
   ld hl,$a282
   
   ret
