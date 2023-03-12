;
; Default value


   defc DEF__register_sp               = 0       ;; initial value of sp (-1 = do not modify (some targets may redefine meaning), 0 = top of memory)

   defc DEF__crt_enable_restart        = 0       ;; if non-zero, restart the program on exit (correct initialization of static variables with rom models only)
   defc DEF__crt_on_exit               = 0x10001 ;; halt on exit (see documentation for other exit behaviours)
   defc DEF__crt_enable_eidi           = 0       ;; bit flags: 0x01 = di on start, 0x02 = ei on start, 0x10 = di on exit, 0x20 = ei on exit

   defc DEF__crt_enable_rst            = 0       ;; if non-zero and in some crts with code org = 0, set bits indicate which rst locations are implemented with user code
   defc DEF__crt_enable_nmi            = 0       ;; if non-zero and in some crts with code org = 0, a jump to user code to service the nmi is inserted


   ; clib defaults
   defc DEF__clib_exit_stack_size      = 32      ;; max number of functions that can be registered with atexit()

   defc DEF__clib_banking_stack_size   = 100	 ;; For each bank call we save 2 words on the temporary stack
