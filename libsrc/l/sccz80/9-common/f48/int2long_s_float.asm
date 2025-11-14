;       Small C+ Z88 Support Library
;
;       Convert signed int to long

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_int2long_s_float

EXTERN float

l_int2long_s_float:

   ; If MSB of h sets de to 255, if not sets de=0

   ld de,0
IF __CPU_INTEL__
   ld a,h
   rla
   jp nc,float
ELSE
   bit 7,h
   jp z, float
ENDIF
   
   dec de
   jp float
