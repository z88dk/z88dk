
SECTION code_fp_math48

PUBLIC am48_dcmpa

EXTERN mm48__cmp2

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

defc am48_dcmpa = mm48__cmp2
