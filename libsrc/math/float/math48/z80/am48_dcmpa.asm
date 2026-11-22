
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dcmpa

EXTERN mm48__cmp2

am48_dcmpa:

   ; compare absolute values of AC and AC' (effective |AC| - |AC'|)
   ;
   ; enter : AC  = double x
   ;         AC' = double y
   ;
   ; exit  : z flag set                    if |x| == |y|
   ;         z flag reset and c flag set   if |x| < |y|
   ;         z flag reset and c flag reset if |x| > |y|
   ;
   ; uses  : af
   
   push bc
   res 7,b
   exx
   push bc
   res 7,b
   exx
   
   call mm48__cmp2
   
   exx
   pop bc
   exx
   pop bc

   ret
