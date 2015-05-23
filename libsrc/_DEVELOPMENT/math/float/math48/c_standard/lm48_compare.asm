
SECTION code_fp_math48

PUBLIC lm48_compare

EXTERN mm48_cmp

   ; compare AC and AC'
   ;
   ; enter : AC (BCDEHL ) = double x
   ;         AC'(BCDEHL') = double y
   ;
   ; exit  : z flag set                    if x == y
   ;         z flag reset and c flag set   if x < y
   ;         z flag reset and c flag reset if x > y
   ;
   ; uses  : af

defc lm48_compare = mm48_cmp
