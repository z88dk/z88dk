
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt config default ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; applied after user configuration to set sensible defaults

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; stdlib
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IF CLIB_EXIT_STACK_SIZE

      defc __crt_cfg_exit_stack_size = CLIB_EXIT_STACK_SIZE

   ELSE
   
      IF __crt_cfg_exit_stack_size

         defc __exit_stack_size = __crt_cfg_exit_stack_size

      ELSE

         defc __exit_stack_size = 32

      ENDIF
   
   ENDIF

   IF CLIB_QUICKEXIT_STACK_SIZE

      defc __crt_cfg_quickexit_stack_size = CLIB_QUICKEXIT_STACK_SIZE

   ELSE

      IF __crt_cfg_quickexit_stack_size

         defc __quickexit_stack_size = __crt_cfg_quickexit_stack_size

      ELSE

         defc __quickexit_stack_size = 32

      ENDIF

   ENDIF
