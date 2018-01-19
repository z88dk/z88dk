
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
