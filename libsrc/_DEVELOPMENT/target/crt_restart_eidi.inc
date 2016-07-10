   IF (__crt_enable_eidi & 0x01)
   
      di
      
   ELSE
   
      IF (__crt_enable_eidi & 0x02)
      
         ei
         
      ENDIF
      
   ENDIF
