
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dsub_s

EXTERN am48_dsub

am48_dsub_s:

   ; Subtract double on stack from AC'
   ;
   ; enter :   AC' = double x
   ;         stack = double y, ret
   ;
   ; exit  : AC = double y
   ;
   ;         success
   ;
   ;            AC'= x - y
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'= +-inf
   ;            carry set, errno set
   ;
   ; uses  : AF, BC, DE, HL, AF', BC', DE', HL'
   
   pop af
   
   pop hl                      ; AC = y
   pop de
   pop bc

   push af
   
   jp am48_dsub
