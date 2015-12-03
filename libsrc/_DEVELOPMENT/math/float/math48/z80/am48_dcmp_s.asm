
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dcmp_s

EXTERN am48_dcmp

   ; compare double on stack to AC' (effective double - AC')
   ;
   ; enter : AC'   = double y
   ;         stack = double x, ret
   ;
   ; exit  : AC' = double y
   ;         AC  = double x
   ;
   ;         z flag set                    if x == y
   ;         z flag reset and c flag set   if x < y
   ;         z flag reset and c flag reset if x > y
   ;
   ; uses  : AF, BC, DE, HL

   pop af
   
   pop hl                      ; AC = x
   pop de
   pop bc
   
   push af
   
   jp am48_dcmp
