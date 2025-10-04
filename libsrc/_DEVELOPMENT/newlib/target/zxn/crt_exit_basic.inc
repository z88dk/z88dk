      ; returning to basic
      
      pop bc
      
      ld sp,(__sp_or_ret)
      
      exx
      pop hl
      exx
      pop iy
      
      IF (__crt_interrupt_mode_exit >= 0) && (__crt_interrupt_mode_exit <= 2)

         im __crt_interrupt_mode_exit

      ENDIF

      ei
      ret
