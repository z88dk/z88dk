
SECTION code_clib
SECTION code_l

PUBLIC l_valid_base

l_valid_base:

   ; check if base is in [2-36

   ;
   ; enter : bc = base
   ;
   ; exit  :  a = base
   ;         carry set indicates valid base
   ;         z flag set and carry reset if base == 0
   ;
   ; uses  : af

   ld a,b
   or a
   ret nz
   
   or c
   ret z
   
   ld a,c
   cp 37
   ret nc
   
   cp 2
   ccf
   ret
