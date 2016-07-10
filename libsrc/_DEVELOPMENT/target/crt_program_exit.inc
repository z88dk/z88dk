
   IF (__crt_on_exit & 0x10000)
   
      IF (__crt_on_exit & 0x8)
      
         ; program restarts
         
         IF (__crt_enable_commandline < 2)
         
            IF (__register_sp = -1)
         
               ld sp,(__sp_or_ret)
            
            ENDIF
         
            jp __Restart
         
         ELSE
         
            IF (__register_sp = -1)
            
               ld sp,(__sp_or_ret)
            
            ELSE
            
               ld sp,__register_sp
               
            ENDIF
            
            INCLUDE "../crt_cmdline_empty.inc"
            
            jp __Restart_2
            
         ENDIF
         
      ELSE
      
         pop hl                ; hl = return status
      
         IF (__crt_on_exit & 0x2)
         
            ; program returns to caller

            ld sp,(__sp_or_ret)
            ret
         
         ELSE
         
            IF (__crt_on_exit & 0x4)
            
            ; program jumps to caller

               ld de,(__sp_or_ret)
               push de
               ret
               
            ELSE
            
               ; program halts

               halt
               jr ASMPC
               
            ENDIF
            
         ENDIF
         
      ENDIF
   
   ELSE
   
      ; program jumps to absolute address
	  
      pop hl                   ; hl = return status
      jp __crt_on_exit
   
   ENDIF
