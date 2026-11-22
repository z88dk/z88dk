
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_load_dehl_deix

____sdcc_load_dehl_deix:

IFDEF __SDCC_IX
   
   push ix
   
ELSE

   push iy

ENDIF

   pop hl
   add hl,de
   
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   
   ret
