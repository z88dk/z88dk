;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       6/9/98  djm

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_asl

EXTERN l_lsl_hl

l_asl:

   ; shift DE left arithmetically by HL, move to HL

   ld a,l
   ex de,hl
   
   jp l_lsl_hl
