
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt rules ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


   IF DEFINED_myzorg
   
      defc __crt_org_code = myzorg
   
   ELSE
   
      IF DEFINED_CRT_ORG_CODE
      
         defc __crt_org_code = CRT_ORG_CODE
      
      ELSE
      
         IF DEFINED_TAR__crt_org_code
         
            defc __crt_org_code = TAR__crt_org_code
         
         ELSE
         
            defc __crt_org_code = DEF__crt_org_code
         
         ENDIF
      
      ENDIF
         
   ENDIF


   IF DEFINED_REGISTER_SP
   
      defc __register_sp = REGISTER_SP
   
   ELSE
   
      IF DEFINED_STACKPTR
      
         defc __register_sp = STACKPTR
      
      ELSE
      
         IF DEFINED_TAR__register_sp
         
            defc __register_sp = TAR__register_sp
         
         ELSE
         
            defc __register_sp = DEF__register_sp
         
         ENDIF
         
      ENDIF
   
   ENDIF
   
      
   IF DEFINED_CRT_ORG_DATA
   
      defc __crt_org_data = CRT_ORG_DATA
   
   ELSE
   
      IF DEFINED_TAR__crt_org_data
      
         defc __crt_org_data = TAR__crt_org_data
      
      ELSE
      
         defc __crt_org_data = DEF__crt_org_data
      
      ENDIF
   
   ENDIF
   
   
   IF DEFINED_CRT_ORG_BSS
   
      defc __crt_org_bss = CRT_ORG_BSS
   
   ELSE
   
      IF DEFINED_TAR__crt_org_bss
      
         defc __crt_org_bss = TAR__crt_org_bss
      
      ELSE
      
         defc __crt_org_bss = DEF__crt_org_bss
      
      ENDIF
   
   ENDIF
   
   
   IF DEFINED_CRT_MODEL
   
      defc __crt_model = CRT_MODEL
   
   ELSE
   
      IF DEFINED_TAR__crt_model
      
         defc __crt_model = TAR__crt_model
      
      ELSE
      
         defc __crt_model = DEF__crt_model
      
      ENDIF
   
   ENDIF
   
   
   IF DEFINED_CRT_ENABLE_COMMANDLINE
   
      defc __crt_enable_commandline = CRT_ENABLE_COMMANDLINE
   
   ELSE
   
      IF DEFINED_TAR__crt_enable_commandline
      
         defc __crt_enable_commandline = TAR__crt_enable_commandline
      
      ELSE
      
         defc __crt_enable_commandline = DEF__crt_enable_commandline
      
      ENDIF
   
   ENDIF
   
   
   IF DEFINED_CRT_ENABLE_RESTART
   
      defc __crt_enable_restart = CRT_ENABLE_RESTART
   
   ELSE
   
      IF DEFINED_TAR__crt_enable_restart
      
         defc __crt_enable_restart = TAR__crt_enable_restart
      
      ELSE
      
         defc __crt_enable_restart = DEF__crt_enable_restart
      
      ENDIF
   
   ENDIF
   
   
   IF DEFINED_CRT_ENABLE_CLOSE
   
      defc __crt_enable_close = CRT_ENABLE_CLOSE
   
   ELSE
   
      IF DEFINED_TAR__crt_enable_close
      
         defc __crt_enable_close = TAR__crt_enable_close
      
      ELSE
      
         defc __crt_enable_close = DEF__crt_enable_close
      
      ENDIF
   
   ENDIF
   
   
   IF DEFINED_CLIB_EXIT_STACK_SIZE
   
      defc __clib_exit_stack_size = CLIB_EXIT_STACK_SIZE
   
   ELSE
   
      IF DEFINED_TAR__clib_exit_stack_size
      
         defc __clib_exit_stack_size = TAR__clib_exit_stack_size
      
      ELSE
      
         defc __clib_exit_stack_size = DEF__clib_exit_stack_size
      
      ENDIF
   
   ENDIF
   
   
   IF DEFINED_CLIB_QUICKEXIT_STACK_SIZE
   
      defc __clib_quickexit_stack_size = CLIB_QUICKEXIT_STACK_SIZE

   ELSE
   
      IF DEFINED_TAR__clib_quickexit_stack_size
      
         defc __clib_quickexit_stack_size = TAR__clib_quickexit_stack_size
      
      ELSE
      
         defc __clib_quickexit_stack_size = DEF__clib_quickexit_stack_size
      
      ENDIF
      
   ENDIF
   
   
   IF DEFINED_CLIB_MALLOC_HEAP_SIZE
   
      defc __clib_malloc_heap_size = CLIB_MALLOC_HEAP_SIZE
   
   ELSE
   
      IF DEFINED_TAR__clib_malloc_heap_size
      
         defc __clib_malloc_heap_size = TAR__clib_malloc_heap_size
      
      ELSE
      
         defc __clib_malloc_heap_size = DEF__clib_malloc_heap_size
      
      ENDIF

   ENDIF

   
   IF DEFINED_CLIB_STDIO_HEAP_SIZE
   
      defc __clib_stdio_heap_size = CLIB_STDIO_HEAP_SIZE
   
   ELSE
   
      IF DEFINED_TAR__clib_stdio_heap_size
      
         defc __clib_stdio_heap_size = TAR__clib_stdio_heap_size
      
      ELSE
      
         defc __clib_stdio_heap_size = DEF__clib_stdio_heap_size
   
      ENDIF
   
   ENDIF
   
   
   IF DEFINED_CLIB_BALLOC_TABLE_SIZE
   
      defc __clib_balloc_table_size = CLIB_BALLOC_TABLE_SIZE
   
   ELSE
   
      IF DEFINED_TAR__clib_balloc_table_size
      
         defc __clib_balloc_table_size = TAR__clib_balloc_table_size
      
      ELSE
      
         defc __clib_balloc_table_size = DEF__clib_balloc_table_size
      
      ENDIF
   
   ENDIF
   
   
   IF DEFINED_CLIB_FOPEN_MAX
   
      defc __clib_fopen_max = CLIB_FOPEN_MAX
   
   ELSE
   
      IF DEFINED_TAR__clib_fopen_max
      
         defc __clib_fopen_max = TAR__clib_fopen_max
      
      ELSE
      
         defc __clib_fopen_max = DEF__clib_fopen_max
      
      ENDIF
   
   ENDIF
   
   
   IF DEFINED_CLIB_OPEN_MAX
   
      defc __clib_open_max = CLIB_OPEN_MAX

   ELSE
   
      IF DEFINED_TAR__clib_open_max
      
         defc __clib_open_max = TAR__clib_open_max
      
      ELSE
      
         defc __clib_open_max = DEF__clib_open_max
      
      ENDIF
      
   ENDIF

;; end crt rules ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
