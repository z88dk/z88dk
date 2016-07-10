   IF (__crt_enable_eidi & 0x10)
   
      di
      
   ELSE
   
      IF (__crt_enable_eidi & 0x20)
      
         ei
         
      ENDIF
      
   ENDIF
