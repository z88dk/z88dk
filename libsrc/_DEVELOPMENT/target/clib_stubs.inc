
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
   
   ; dynamic printf

   IFNDEF CLIB_OPT_PRINTF
      IFDEF CLIB_OPT_PRINTF_2
         defc CLIB_OPT_PRINTF = 0
      ENDIF
   ENDIF

   IFNDEF CLIB_OPT_PRINTF_2
      IFDEF CLIB_OPT_PRINTF
         defc CLIB_OPT_PRINTF_2 = 0
      ENDIF
   ENDIF
   
   IFDEF CLIB_OPT_PRINTF
      
      IF __SDCC_IY
      
         INCLUDE "../../stdio/z80/asm_vfprintf_unlocked_iy.asm"
      
      ELSE
      
         INCLUDE "../../stdio/z80/asm_vfprintf_unlocked.asm"
   
      ENDIF
      
   ENDIF
   
   ; dynamic scanf

   IFNDEF CLIB_OPT_SCANF
      IFDEF CLIB_OPT_SCANF_2
         defc CLIB_OPT_SCANF = 0
      ENDIF
   ENDIF

   IFNDEF CLIB_OPT_SCANF_2
      IFDEF CLIB_OPT_SCANF
         defc CLIB_OPT_SCANF_2 = 0
      ENDIF
   ENDIF
   
   IFDEF CLIB_OPT_SCANF
      
      IF __SDCC_IY
      
         INCLUDE "../../stdio/z80/asm_vfscanf_unlocked_iy.asm"
      
      ELSE
      
         INCLUDE "../../stdio/z80/asm_vfscanf_unlocked.asm"
   
      ENDIF
   
   ENDIF
