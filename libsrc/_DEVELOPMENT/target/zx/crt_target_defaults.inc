
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CRT TARGET DEFAULTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; opportunity for target to override library defaults
   
   defc __crt_org_code           = 32768
   defc __crt_model              = 0      ; ram model
   
   defc __register_sp            = 0      ; crt does not modify
   
   defc __crt_enable_commandline = 0
   defc __crt_enable_restart     = 0
   
   defc __clib_fopen_max         = 3
   defc __clib_open_max          = 3

   defc __clib_exit_stack_size      = 2
   defc __clib_quickexit_stack_size = 0

;; END CRT TARGET DEFAULTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
