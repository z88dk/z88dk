
SECTION code_l_sdcc

PUBLIC __sdcc_enter_ix

__sdcc_enter_ix:

   pop hl

   push ix

   ld ix,0
   add ix,sp
   
   jp (hl)
