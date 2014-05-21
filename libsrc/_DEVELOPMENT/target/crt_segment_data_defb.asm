
;==============================================================
;= crt segment data allocate space ============================

; data that is initialized to non-zero values at startup

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; alloc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; balloc's queue table

IF __crt_cfg_qtbl_size > 0

   PUBLIC __qtbl
   
   __qtbl:                     defw __qtbl_address

ENDIF

; malloc's heap

IF __crt_cfg_heap_size > 14

   PUBLIC __heap
   
   __heap:                     defw __heap_address

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; stdio
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __stdio_file_list_lock, __stdio_file_list_open, __stdio_file_list_avail

__stdio_file_list_lock:        defb 0, 1, 0, $fe, 0, 0

__stdio_file_list_open:        IF __crt_cfg_file_enable & $01

                                  defw __CRT_FILE_STDIN - 2
                               
                               ENDIF
                               
                               IF (__crt_cfg_file_enable & $03) = 2
                               
                                  defw __CRT_FILE_STDOUT - 2
                               
                               ENDIF
                               
                               IF (__crt_cfg_file_enable & $07) = 4
                               
                                  defw __CRT_FILE_STDERR - 2
                               
                               ENDIF
                               
                               IF (__crt_cfg_file_enable & $07) = 0
                               
                                  defw 0
                               
                               ENDIF

__stdio_file_list_avail:       defw 0
                               defw __stdio_file_list_avail

IF __crt_cfg_file_enable & $01

   PUBLIC __stdio_file_stdin
   __stdio_file_stdin:         defw __CRT_FILE_STDIN

ENDIF

IF __crt_cfg_file_enable & $02

   PUBLIC __stdio_file_stdout
   __stdio_file_stdout:        defw __CRT_FILE_STDOUT

ENDIF

IF __crt_cfg_file_enable & $04

   PUBLIC __stdio_file_stderr
   __stdio_file_stderr:        defw __CRT_FILE_STDERR

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; stdlib
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __seed

__seed:                        defw 1, 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; threads
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __thrd_id

__thrd_id:                     defb 1

;==============================================================
