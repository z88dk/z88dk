
;==============================================================
;= crt segment bss externally allocated =======================

; data that is zeroed at startup

PUBLIC __exit_stack, __exit_stack_size
PUBLIC __quickexit_stack, __quickexit_stack_size
PUBLIC _errno, __strtok_ptr

defvars -1
{
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; errno
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   _errno                      ds.w 1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; string
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   __strtok_ptr                ds.w 1
}

IF __crt_cfg_qtbl_size > 0

   defvars -1
   {
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ; alloc
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

      ; balloc's queue table

      __qtbl_address           ds.w __crt_cfg_qtbl_size
   }

ENDIF

defvars -1
{
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; stdlib
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; exit stack

   __exit_stack
}

IF __exit_stack_size > 0

   defvars -1
   {
      ds.b 1
      ds.w __exit_stack_size
   }

ENDIF

defvars -1
{
   ; quick_exit stack

   __quickexit_stack
}

IF __quickexit_stack_size > 0

   defvars -1
   {
      ds.b 1
      ds.w __quickexit_stack_size
   }

ENDIF

IF __crt_cfg_heap_size > 14

   defvars -1
   {
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ; alloc
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

      ; malloc's heap
   
      __heap_address           ds.b __crt_cfg_heap_size
   }

ENDIF

IF __crt_cfg_fopen_max > 3

   defvars -1
   {
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ; stdio
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
      __file_block             ds.b (__CLIB_OPT_STDIO_FILE_EXTRA + 15) * (__crt_cfg_fopen_max - 3)
   }

ENDIF

;==============================================================
