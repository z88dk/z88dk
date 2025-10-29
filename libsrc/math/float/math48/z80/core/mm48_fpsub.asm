
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48_fpsub, mm48__sub1

EXTERN mm48__add1, mm48_negate, am48_dneg

mm48_fpsub:

   ; floating point subtract
   ; AC' = AC' - AC
   ;
   ; enter : AC (BCDEHL ) = float a
   ;         AC'(BCDEHL') = float b
   ;
   ; exit  : AC (BCDEHL ) unchanged
   ;
   ;         success
   ;
   ;            AC'(BCDEHL') = b - a
   ;            carry reset
   ;
   ;         fail if overflow
   ;
   ;            AC'(BCDEHL') = double_max or double_min
   ;            carry set, errno set
   ;
   ; uses  : af, af', bc', de', hl'

   bit 7,b                     ;is AC negative?
   exx
   
   ; AC' active
   
   jp nz,mm48__add1            ;Ja => ADD1

mm48__sub1:

   ; AC' active

   call mm48_negate            ;negate
   call mm48__add1             ;Laeg AC' til AC

   ; result in AC'
   
   ex af,af'                   ;save carry status
   call am48_dneg              ;negate result
   ex af,af'
   ret
