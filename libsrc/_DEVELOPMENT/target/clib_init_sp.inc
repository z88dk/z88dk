
   ; change stack address
   
   IF __register_sp != 0
      
      IF __register_sp = -1
      
         ld sp,0
      
      ELSE
      
         ld sp,__register_sp
      
      ENDIF
   
   ENDIF
