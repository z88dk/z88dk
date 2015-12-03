
SECTION code_clib
SECTION code_l

PUBLIC l_offset_ix_bc

l_offset_ix_bc:

   ; enter : hl = offset
   ;
   ; exit  : bc = ix
   ;         hl = ix + offset

   push ix
   pop bc
   
   add hl,bc
   ret
