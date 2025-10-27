
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48__addac

mm48__addac:

   ;AC = AC + AC'
   ;Laeg AC' til AC.

   ld a,h
   exx
   add a,h

mm48__aac1:

   exx
   ld h,a
   ld a,e
   exx
   adc a,e
   exx
   ld e,a
   ld a,d
   exx
   adc a,d
   exx
   ld d,a
   ld a,c
   exx
   adc a,c
   exx
   ld c,a
   ld a,b
   exx
   adc a,b
   exx
   ld b,a
   
   ret
