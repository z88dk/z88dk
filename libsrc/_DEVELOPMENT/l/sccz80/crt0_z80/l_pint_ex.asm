;       Z88 Small C+ Run time Library
;       Moved functions over to proper libdefs
;       To make startup code smaller and neater!
;
;       23/1/2001  djm

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_pint_ex

l_pint_ex:

   ; store int from HL into (DE)

   ex de,hl
   
   ld (hl),e
   inc hl
   ld (hl),d
   
   ret
