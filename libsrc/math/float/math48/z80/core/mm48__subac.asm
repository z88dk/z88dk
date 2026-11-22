
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48__subac

mm48__subac:

   ;AC = AC - AC'
   ;Traek AC' fra AC.
   
   ld a,h
   exx
   sub h

mm48__sac1:

   exx
   ld h,a
   ld a,e
   exx
   sbc a,e
   exx
   ld e,a
   ld a,d
   exx
   sbc a,d
   exx
   ld d,a
   ld a,c
   exx
   sbc a,c
   exx
   ld c,a
   ld a,b
   exx
   sbc a,b
   exx
   ld b,a
   ret
