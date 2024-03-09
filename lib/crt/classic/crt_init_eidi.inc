; ei/di state at the start of the program 

IF !__CPU_RABBIT__
   IF (__crt_enable_eidi & 0x01)
      di
   ENDIF
   IF (__crt_enable_eidi & 0x02)
      ei
   ENDIF
ENDIF

