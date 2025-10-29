
SECTION code_clib
SECTION code_fp_math48

PUBLIC mm48__cmpac

mm48__cmpac:

   ; compare AC to AC' (AC - AC')

   ld a,b
   exx
   cp b
   exx
   ret nz
   ld a,c
   exx
   cp c
   exx
   ret nz
   ld a,d
   exx
   cp d
   exx
   ret nz
   ld a,e
   exx
   cp e
   exx
   ret nz
   ld a,h
   exx
   cp h
   exx
   ret
