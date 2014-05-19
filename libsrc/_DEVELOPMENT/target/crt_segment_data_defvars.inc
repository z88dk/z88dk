
;==============================================================
;= crt segment data externally allocated ======================

; data that is initialized to non-zero values at startup

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; alloc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_cfg_qtbl_size > 0

   PUBLIC __qtbl

   defvars -1
   {
      ; balloc's queue table
   
      __qtbl                   ds.w 1
   }

ENDIF

IF __crt_cfg_heap_size > 14

   PUBLIC __heap
   
   defvars -1
   {   
      ; malloc's heap
   
      __heap                   ds.w 1
   }

ENDIF

PUBLIC __stdio_file_list_lock, __stdio_file_list_open, __stdio_file_list_avail
PUBLIC __stdio_file_stdin, __stdio_file_stdout, __stdio_file_stderr
PUBLIC _seed, __thrd_id

defvars -1
{   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; stdio
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   __stdio_file_list_lock      ds.b 6
   __stdio_file_list_open      ds.w 1
   __stdio_file_list_avail     ds.w 2
   
   __stdio_file_stdin          ds.w 1
   __stdio_file_stdout         ds.w 1
   __stdio_file_stderr         ds.w 1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; stdlib
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   __seed                      ds.w 2
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; threads
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   __thrd_id                   ds.b 1
}

;==============================================================
