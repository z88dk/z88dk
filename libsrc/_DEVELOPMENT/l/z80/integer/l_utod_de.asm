
SECTION code_clib
SECTION code_l

PUBLIC l_utod_de

l_utod_de:

   ; convert unsigned int to signed int, saturate if necessary
   ;
   ; enter : de = unsigned int
   ;
   ; exit  : de = int, maximum $7fff
   ;         carry unaffected
   ;
   ; uses  : f, hl, a (8080)
   
IF __CPU_INTEL__
   ld a,d
   rla
   ret nc
ELSE
   bit 7,d
   ret z
ENDIF
   
   ld de,$7fff
   ret
