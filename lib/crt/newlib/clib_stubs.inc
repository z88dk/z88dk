
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
   ;
   ; An explicit CLIB_OPT_PRINTF replaces the library dispatcher.
   ; The compilers record scanned literals as CRT_printf_format.
   ; When that mask names a float converter the library was built
   ; without, rebuild vfprintf as the library mask OR the scan.
   ; An integer program keeps the prebuilt object.

   IFNDEF CLIB_OPT_PRINTF
      IFDEF __CLIB_OPT_PRINTF
         IFDEF CRT_printf_format
            ; $3fc00000 is %a %A %e %E %f %F %g %G. Width and precision
            ; ride along in the OR, but they do not rebuild by themselves.
            IF (CRT_printf_format & $3fc00000) != (__CLIB_OPT_PRINTF & $3fc00000)
               defc CLIB_OPT_PRINTF = __CLIB_OPT_PRINTF | CRT_printf_format
               IFNDEF CLIB_OPT_PRINTF_2
                  IFDEF __CLIB_OPT_PRINTF_2
                     defc CLIB_OPT_PRINTF_2 = __CLIB_OPT_PRINTF_2
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF

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
      
         ; path from lib/crt/newlib → libsrc/newlib/stdio (post-#2814 layout)
         INCLUDE "../libsrc/newlib/stdio/z80/asm_vfprintf_unlocked_iy.asm"
      
      ELSE
      
         INCLUDE "../libsrc/newlib/stdio/z80/asm_vfprintf_unlocked.asm"
   
      ENDIF
      
   ENDIF
   
   ; dynamic scanf
   ;
   ; Same rule as printf. CRT_scanf_format is the scanned literal mask.

   IFNDEF CLIB_OPT_SCANF
      IFDEF __CLIB_OPT_SCANF
         IFDEF CRT_scanf_format
            IF (CRT_scanf_format & $3fc00000) != (__CLIB_OPT_SCANF & $3fc00000)
               defc CLIB_OPT_SCANF = __CLIB_OPT_SCANF | CRT_scanf_format
               IFNDEF CLIB_OPT_SCANF_2
                  IFDEF __CLIB_OPT_SCANF_2
                     defc CLIB_OPT_SCANF_2 = __CLIB_OPT_SCANF_2
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF

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
      
         INCLUDE "../libsrc/newlib/stdio/z80/asm_vfscanf_unlocked_iy.asm"
      
      ELSE
      
         INCLUDE "../libsrc/newlib/stdio/z80/asm_vfscanf_unlocked.asm"
   
      ENDIF
   
   ENDIF
