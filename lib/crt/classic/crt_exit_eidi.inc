; ei/di state at the end of the program 

   IF (__crt_enable_eidi & 0x10)
      di
   ENDIF
   IF (__crt_enable_eidi & 0x20)
      ei
   ENDIF

