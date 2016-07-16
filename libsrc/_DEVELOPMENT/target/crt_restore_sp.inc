
   IF (__crt_on_exit & 0x10000)
   
      IF (__crt_on_exit & 0x8)
      
         ; program restarts
         
         IF (__crt_enable_commandline < 2)
         
            IF (__register_sp = -1)
         
               ld sp,(__sp_or_ret)
            
            ENDIF
         
         ELSE
         
            IF (__register_sp = -1)
            
               ld sp,(__sp_or_ret)
            
            ENDIF
            
         ENDIF
         
      ELSE
      
         pop hl                ; hl = return status
      
         IF (__crt_on_exit & 0x2)
         
            ; program returns to caller

            ld sp,(__sp_or_ret)
         
         ENDIF
         
      ENDIF
   
   ELSE
   
      ; program jumps to absolute address
	  
      pop hl                   ; hl = return status
   
   ENDIF
