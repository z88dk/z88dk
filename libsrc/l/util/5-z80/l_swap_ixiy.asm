SECTION code_clib
SECTION code_l

PUBLIC l_swap_ixiy

l_swap_ixiy:

   push ix
   ex (sp),iy
   pop ix
   
   ret
