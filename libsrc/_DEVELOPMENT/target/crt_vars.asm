
; == crt variables ============

;;;;;;;;;;;;;;;;;;;
;; crt host defines
;;;;;;;;;;;;;;;;;;;

;;; host jump table

PUBLIC __ch_system

IF __ch_system_func

   __ch_system:                jp __ch_system_func

ELSE

   EXTERN error_zc
   
   __ch_system:                jp error_zc

ENDIF


;;;;;;;;;;;;;;;;;;
;; crt per process
;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;; alloc

IF __heap_sz > 14

   PUBLIC __heap
   
   IF __heap_loc
   
      __heap:                  defw __heap_loc
   
   ELSE
   
      __heap:                  defw __heap_loc
      __heap_loc:              defs __heap_sz

   ENDIF

ENDIF

IF __qtbl_sz > 0

   PUBLIC __qtbl
   
   IF __qtbl_loc
   
      __qtbl:                  defw __qtbl_loc
   
   ELSE

      __qtbl:                  defw __qtbl_loc
      __qtbl_loc:              defs __qtbl_sz * 2

   ENDIF

ENDIF

;;;;;; exit stacks

IF !__exit_stack_sz

   defc __exit_stack_sz = 32

ENDIF

PUBLIC __exit_stack, __exit_stack_sz

__exit_stack:

IF __exit_stack_sz > 0
   
   defb 0
   defs __exit_stack_sz * 2
      
ENDIF

IF !__quickexit_stack_sz

   defc __quickexit_stack_sz = 32

ENDIF

PUBLIC __quickexit_stack, __quickexit_stack_sz

__quickexit_stack:

IF __quickexit_stack_sz > 0
  
   defb 0
   defs __quickexit_stack_sz * 2

ENDIF

;;;; stack pointer

__sp:          defs 2


;;;;;;;;;;;;;;;;;
;; crt per thread
;;;;;;;;;;;;;;;;;

;;;;;;;;;;;; clib

PUBLIC __thrd_id, _errno

IF __thrd_id_loc

   defc __thrd_id = __thrd_id_loc

ELSE

   __thrd_id:                  defb 1

ENDIF

IF __errno_loc

   defc _errno = __errno_loc

ELSE

   _errno:                     defw 0

ENDIF

;;;;;;;;;; locale

PUBLIC __lc_char_cmp_bc, __lc_char_ordinal

IF __lc_char_cmp_bc_func
   
   __lc_char_cmp_bc:           jp __lc_char_cmp_bc_func

ELSE

   EXTERN __lc_char_cmp_bc_default

   __lc_char_cmp_bc:           jp __lc_char_cmp_bc_default

ENDIF

IF __lc_char_ordinal_func

   __lc_char_ordinal:          jp __lc_char_ordinal_func

ELSE

   EXTERN __lc_char_ordinal_default
   
   __lc_char_ordinal:          jp __lc_char_ordinal_default

ENDIF

;;;;;;;;;;; stdio

IF __HAVE_FILE_STDIN

   PUBLIC __stdio_file_stdin
   
   __stdio_file_stdin:         defw __FILE_STDIN

ENDIF

IF __HAVE_FILE_STDOUT

   PUBLIC __stdio_file_stdout
   
   __stdio_file_stdout:        defw __FILE_STDOUT

ENDIF

IF __HAVE_FILE_STDERR

   PUBLIC __stdio_file_stderr
   
   __stdio_file_stderr:        defw __FILE_STDERR

ENDIF

PUBLIC __stdio_file_list_lock, __stdio_file_list_open, __stdio_file_list_avail

__stdio_file_list_lock:        defs 6
__stdio_file_list_open:        defs 2
__stdio_file_list_avail:       defs 4

;;;;;;;;;; stdlib

PUBLIC __seed

IF __seed_loc

   defc __seed = __seed_loc

ELSE

   __seed:                     defw 1, 1

ENDIF

; string

PUBLIC __strtok_ptr

IF __strtok_loc

   defc __strtok_ptr = __strtok_loc

ELSE

   __strtok_ptr:               defw 0

ENDIF

; =============================

PUBLIC __sound_bit_state
__sound_bit_state:  defb 0
