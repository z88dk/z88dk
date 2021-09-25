
   ; do not save sp if
   ; * program jumps to address on exit
   ; * program halts on exit

   IF (__crt_on_exit & 0x10000)
   
      IF (__crt_on_exit & 0x8)
      
         ; program restarts on exit

         IF (__register_sp = -1)
         
            IF __CPU_INTEL__ || __CPU_GBZ80__
             ld hl,sp
             ld (__sp_or_ret),hl
           ELSE
             ld (__sp_or_ret),sp
           ENDIF
           
         ENDIF
         
      ELSE
      
         IF (__crt_on_exit & 0x2)
         
            ; program returns to caller on exit

            IF __CPU_INTEL__ || __CPU_GBZ80__
              ld hl,sp
              ld (__sp_or_ret),hl
            ELSE
              ld (__sp_or_ret),sp
            ENDIF
         
         ELSE
         
            IF (__crt_on_exit & 0x4)
            
               ; program jumps to caller on exit

               IF (__crt_enable_commandline != 2)
                 pop hl
                 ld (__sp_or_ret),hl
               ELSE
                 pop de
                 IF __CPU_INTEL__ || __CPU_GBZ80__
                   ex de,hl
                   ld (__sp_or_ret),hl
                   ex de,hl
                 ELSE
                   ld (__sp_or_ret),de
                 ENDIF
                 
               ENDIF
               
            ENDIF
            
         ENDIF
         
      ENDIF
      
   ENDIF
