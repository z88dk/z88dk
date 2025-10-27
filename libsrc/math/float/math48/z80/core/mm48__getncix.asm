
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48__getncix, mm48__getcix

mm48__getncix:

;Saet AC lig den konstant IX peger paa.

   ld de,6
   add ix,de

mm48__getcix:

   ld c,(ix+0)
   ld b,(ix+1)
   ld e,(ix+2)
   ld d,(ix+3)
   ld l,(ix+4)
   ld h,(ix+5)
   ret
