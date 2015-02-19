
SECTION code_l_sdcc

PUBLIC ___sdcc_enter_ix

___sdcc_enter_ix:

   pop hl

   push ix

   ld ix,0
   add ix,sp
   
   jp (hl)
