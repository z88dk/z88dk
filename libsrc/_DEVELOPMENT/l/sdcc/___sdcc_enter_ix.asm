
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ___sdcc_enter_ix

___sdcc_enter_ix:

IF __SDCC_IX

   pop hl

   push ix

   ld ix,0
   add ix,sp
   
   jp (hl)

ELSE

   pop hl
   
   push iy
   
   ld iy,0
   add iy,sp
   
   jp (hl)

ENDIF
