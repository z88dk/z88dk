
SECTION code_fp_math48

PUBLIC lm48__float_error_pinfnc

EXTERN mm48__acpinfc

   pop hl
   pop hl

lm48__float_error_pinfnc:

   ; exit : AC'= +infinity
   ;        carry reset
   ;
   ; uses : f, bc', de', hl'
   
   exx
   call mm48__acpinfc
   exx
   
   ccf
   ret
