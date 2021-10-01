;       Small C+ Z88 Support Library
;
;	Decrement long on hl
;	Kept little endian
;
;       djm 26/2/2000

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_long_dec

l_long_dec:

   ; dec long at address hl
   
   ld a,$ff
   
   dec (hl)
   cp (hl)
   ret nz
   
   inc hl
   dec (hl)
   cp (hl)
   ret nz

   inc hl
   dec (hl)
   cp (hl)
   ret nz
   
   inc hl
   dec (hl)
   ret
