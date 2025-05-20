; ei/di state at the end of the program 

   IF (__crt_enable_eidi & 0x10)
      di
   ENDIF

IF !__CPU_INTEL__ && !__CPU_GBZ80__ && !__CPU_RABBIT__
   IF (__crt_interrupt_mode_exit >= 0) && (__crt_interrupt_mode_exit <= 2)
         im __crt_interrupt_mode_exit
   ENDIF
ENDIF

   IF (__crt_enable_eidi & 0x20)
      ei
   ENDIF

