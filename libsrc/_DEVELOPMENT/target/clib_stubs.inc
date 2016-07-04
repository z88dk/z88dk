
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; unimplemented
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   ; system()
   
   PUBLIC __ch_system
   
   EXTERN error_zc
   
   defc __ch_system = error_zc
   
   ; threads
   ; these functions are preliminary only
   
   PUBLIC __thread_context_switch
   PUBLIC __thread_block_timeout
   PUBLIC __thread_unblock

   EXTERN l_ret

   defc __thread_context_switch = l_ret
   defc __thread_block_timeout  = l_ret
   defc __thread_unblock        = l_ret

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; dynamically generated functions
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   IF !DEFINED_CLIB_OPT_STDIO
      defc DEFINED_CLIB_OPT_STDIO = 1
      defc CLIB_OPT_STDIO = 0
   ENDIF
   
   defc __CLIB_OPT_STDIO = CLIB_OPT_STDIO
   
   ; dynamic printf
   
   IF DEFINED_CLIB_OPT_PRINTF
      IF !DEFINED_CLIB_OPT_PRINTF_2
         defc DEFINED_CLIB_OPT_PRINTF_2 = 1
         defc CLIB_OPT_PRINTF_2 = 0
      ENDIF
   ENDIF
   
   IF DEFINED_CLIB_OPT_PRINTF_2
      IF !DEFINED_CLIB_OPT_PRINTF
         defc DEFINED_CLIB_OPT_PRINTF = 1
         defc CLIB_OPT_PRINTF = 0
      ENDIF
   ENDIF
   
   IF DEFINED_CLIB_OPT_PRINTF
   
      defc __CLIB_OPT_PRINTF = CLIB_OPT_PRINTF
      defc __CLIB_OPT_PRINTF_2 = CLIB_OPT_PRINTF_2
      
      INCLUDE "../../stdio/z80/asm_vfprintf_unlocked.asm"
   
   ENDIF
   
   ; dynamic scanf

   IF DEFINED_CLIB_OPT_SCANF
      IF !DEFINED_CLIB_OPT_SCANF_2
         defc DEFINED_CLIB_OPT_SCANF_2 = 1
         defc CLIB_OPT_SCANF_2 = 0
      ENDIF
   ENDIF
   
   IF DEFINED_CLIB_OPT_SCANF_2
      IF !DEFINED_CLIB_OPT_SCANF
         defc DEFINED_CLIB_OPT_SCANF = 1
         defc CLIB_OPT_SCANF = 0
      ENDIF
   ENDIF
   
   IF DEFINED_CLIB_OPT_SCANF
   
      defc __CLIB_OPT_SCANF = CLIB_OPT_SCANF
      defc __CLIB_OPT_SCANF_2 = CLIB_OPT_SCANF_2
      
      INCLUDE "../../stdio/z80/asm_vfscanf_unlocked.asm"
   
   ENDIF
