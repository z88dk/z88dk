
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt segment bss defvars - external ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; errno
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   PUBLIC _errno

   defvars -1
   {
      _errno                      ds.w 1
   }

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; string
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   PUBLIC __strtok_ptr

   defvars -1
   {   
      __strtok_ptr                ds.w 1
   }

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; alloc
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; balloc's queue table

   IF __crt_cfg_qtbl_size > 0

      defvars -1
      {
         __qtbl_address           ds.w __crt_cfg_qtbl_size
      }

   ENDIF

   IF __crt_cfg_heap_size > 14

      defvars -1
      {
         __heap_address           ds.b __crt_cfg_heap_size
      }

   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; stdlib
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   PUBLIC __exit_stack, __exit_stack_size

   defvars -1
   {
      __exit_stack
   }

   IF __exit_stack_size > 0

      defvars -1
      {
         ds.b 1
         ds.w __exit_stack_size
      }

   ENDIF

   PUBLIC __quickexit_stack, __quickexit_stack_size

   defvars -1
   {
      __quickexit_stack
   }

   IF __quickexit_stack_size > 0

      defvars -1
      {
         ds.b 1
         ds.w __quickexit_stack_size
      }

   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; stdio
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IF (__crt_cfg_fopen_max < 128) & (__crt_cfg_fopen_max > 3)

      defvars -1
         __file_block             ds.b (__CLIB_OPT_STDIO_FILE_EXTRA + 15) * (__crt_cfg_fopen_max - 3)
      }

   ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
