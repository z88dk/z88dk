
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dcmp

EXTERN mm48_cmp

   ; compare AC and AC' (effective AC - AC')
   ;
   ; enter : AC  = double x
   ;         AC' = double y
   ;
   ; exit  : z flag set                    if x == y
   ;         z flag reset and c flag set   if x < y
   ;         z flag reset and c flag reset if x > y
   ;
   ; uses  : af

defc am48_dcmp = mm48_cmp
