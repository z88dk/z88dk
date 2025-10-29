
SECTION code_clib
SECTION code_l

PUBLIC l_offset_ix_de

l_offset_ix_de:

   ; enter : hl = offset
   ;
   ; exit  : de = ix
   ;         hl = ix + offset

   push ix
   pop de
   
   add hl,de
   ret
