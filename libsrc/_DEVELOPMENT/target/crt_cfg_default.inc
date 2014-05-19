
; == crt config default =======================================

; configuration applied after user configuration for defaults

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; stdlib
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; exit stack

IF __crt_cfg_exit_stack_size

   defc __exit_stack_size = __crt_cfg_exit_stack_size

ELSE

   defc __exit_stack_size = 32

ENDIF

; quickexit stack

IF __crt_cfg_quickexit_stack_size

   defc __quickexit_stack_size = __crt_cfg_quickexit_stack_size

ELSE

   defc __quickexit_stack_size = 32

ENDIF

; =============================
