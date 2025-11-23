
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48__sright, mm48__right

mm48__sright:

   ;rotate AC right
   
   or a

mm48__right:

   rr b
   rr c
   rr d
   rr e
   rr h
   
   ret
