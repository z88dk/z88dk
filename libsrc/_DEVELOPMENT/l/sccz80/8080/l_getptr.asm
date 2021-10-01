;       Z88 Small C+ Run Time Library 
;
;       Get Long Pointer from Near Memory

IF !__CPU_GBZ80__
SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_getptr

l_getptr:

   ; fetch far ptr from address hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld l,(hl)
   ld h,0
   
   ex de,hl
   ret
ENDIF
