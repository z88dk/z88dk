   IF (__crt_enable_eidi & 0x10)
   
      di

      IF (__crt_interrupt_mode_exit >= 0) && (__crt_interrupt_mode_exit <= 2)

         im __crt_interrupt_mode_exit

      ENDIF
      
   ELSE

      IF (__crt_enable_eidi & 0x20)
      
         IF (__crt_interrupt_mode_exit >= 0) && (__crt_interrupt_mode_exit <= 2)

            im __crt_interrupt_mode_exit

         ENDIF

         ei

      ENDIF
      
   ENDIF
