
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT RULES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IF !myzorg
   
      IF CRT_ORG_CODE
      
         defc myzorg = CRT_ORG_CODE
      
      ELSE
      
         defc myzorg = __crt_org_code
         
   ENDIF

   IF REGISTER_SP
   
      defc __register_sp = REGISTER_SP
   
   ELSE
   
      IF STACKPTR
      
         defc __register_sp = STACKPTR
      
      ENDIF
   
   ENDIF
   
   IF CRT_ORG_DATA
   
      defc __crt_org_data = CRT_ORG_DATA
   
   ENDIF
   
   IF CRT_ORG_BSS
   
      defc __crt_org_bss = CRT_ORG_BSS
   
   ENDIF
   
   IF CRT_MODEL
   
      defc __crt_model = CRT_MODEL
   
   ENDIF
   
   IF CLIB_EXIT_STACK_SIZE
   
      defc __clib_exit_stack_size = CLIB_EXIT_STACK_SIZE
   
   ENDIF
   
   IF CLIB_QUICKEXIT_STACK_SIZE
   
      defc __clib_quickexit_stack_size = CLIB_QUICKEXIT_STACK_SIZE

   ENDIF
   
   IF CLIB_MALLOC_HEAP_SIZE
   
      defc __clib_malloc_heap_size = CLIB_MALLOC_HEAP_SIZE
   
   ENDIF
   
   IF CLIB_STDIO_HEAP_SIZE
   
      defc __clib_stdio_heap_size = CLIB_STDIO_HEAP_SIZE
   
   ENDIF
   
   IF CLIB_BALLOC_TABLE_SIZE
   
      defc __clib_balloc_table_size = CLIB_BALLOC_TABLE_SIZE
   
   ENDIF
   
   IF CLIB_FOPEN_MAX
   
      defc __clib_fopen_max = CLIB_FOPEN_MAX
   
   ENDIF
   
   IF CLIB_OPEN_MAX
   
      defc __clib_open_max = CLIB_OPEN_MAX

   ENDIF

;; END CRT RULES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
