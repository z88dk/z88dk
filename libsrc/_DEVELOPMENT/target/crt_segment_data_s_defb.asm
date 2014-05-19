
;==============================================================
;= crt segment data stored copy ===============================

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; alloc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; balloc's queue table

IF __crt_cfg_qtbl_size > 0

   __qtbl_s:                   defw __qtbl_address

ENDIF

; malloc's heap

IF __crt_cfg_heap_size > 14

   __heap_s:                   defw __heap_address

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; stdio
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__stdio_file_list_lock_s:      defb 0, 1, 0, $fe, 0, 0

__stdio_file_list_open_s:      defw __CRT_FILE_STDIN - 2

__stdio_file_list_avail_s:     defw 0
                               defw __stdio_file_list_avail

__stdio_file_stdin_s:          defw __CRT_FILE_STDIN
__stdio_file_stdout_s:         defw __CRT_FILE_STDOUT
__stdio_file_stderr_s:         defw __CRT_FILE_STDERR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; stdlib
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__seed_s:                      defw 1, 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; threads
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__thrd_id_s:                   defb 1

;==============================================================
