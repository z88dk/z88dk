
   IFNDEF CRT_INITIALIZE_BSS
      defc CRT_INITIALIZE_BSS = 1
   ENDIF

   IFDEF REGISTER_SP
      defc __register_sp = REGISTER_SP
   ELSE
      IFDEF STACKPTR
         defc __register_sp = STACKPTR
      ELSE
         IFDEF TAR__register_sp
            defc __register_sp = TAR__register_sp
         ELSE
            defc __register_sp = DEF__register_sp
         ENDIF
      ENDIF
   ENDIF

   IFDEF CLIB_EXIT_STACK_SIZE
      defc __clib_exit_stack_size = CLIB_EXIT_STACK_SIZE
   ELSE
      IFDEF TAR__clib_exit_stack_size
         defc __clib_exit_stack_size = TAR__clib_exit_stack_size
      ELSE
         defc __clib_exit_stack_size = DEF__clib_exit_stack_size
      ENDIF
   ENDIF


   PUBLIC __CRT_KEY_DEL
   IFDEF CRT_KEY_DEL
     defc __CRT_KEY_DEL = CRT_KEY_DEL
   ELSE
     defc __CRT_KEY_DEL = 8
   ENDIF

   PUBLIC __CRT_KEY_CAPS_LOCK
   IFDEF CRT_KEY_CAPS_LOCK
     defc __CRT_KEY_CAPS_LOCK  = CRT_KEY_CAPS_LOCK
   ELSE
     defc __CRT_KEY_CAPS_LOCK = 6
   ENDIF

   PUBLIC __CPU_CLOCK
   IFNDEF __CPU_CLOCK
     defc __CPU_CLOCK = 3500000
   ENDIF
