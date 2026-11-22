
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dldpush

EXTERN am48_dload

am48_dldpush:

   ; load double from memory and push onto stack
   ;
   ; enter : hl = double *
   ;
   ; exit  :    AC = double x (*hl)
   ;         stack = double x (*hl)
   ;
   ; uses  : af, bc, de, hl

   call am48_dload
   exx
   
   pop af
   
   push bc
   push de
   push hl
   
   push af
   ret
