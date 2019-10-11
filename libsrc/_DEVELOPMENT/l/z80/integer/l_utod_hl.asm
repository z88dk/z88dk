
SECTION code_clib
SECTION code_l

PUBLIC l_utod_hl

l_utod_hl:

   ; convert unsigned int to signed int, saturate if necessary
   ;
   ; enter : hl = unsigned int
   ;
   ; exit  : hl = int, maximum $7fff
   ;         carry unaffected
   ;
   ; uses  : f, hl + a (8080)
IF __CPU_INTEL__
   ld a,h
   rla
   ret nc
ELSE
   bit 7,h
   ret z
ENDIF
   
   ld hl,$7fff
   ret
