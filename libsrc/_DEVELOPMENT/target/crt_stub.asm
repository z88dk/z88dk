
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt stubs ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; host
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; system() function

   PUBLIC __ch_system

   IF __crt_cfg_system_address

      __ch_system:                jp __crt_cfg_system_address

   ELSE

      EXTERN error_zc
   
      __ch_system:                jp error_zc

   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; locale
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; assign ordinal to local-specific chars

   PUBLIC __lc_char_ordinal

   IF __crt_cfg_lc_char_ordinal_address

      __lc_char_ordinal:          jp __crt_cfg_lc_char_ordinal_address

   ELSE

      EXTERN __lc_char_ordinal_default
   
      __lc_char_ordinal:          jp __lc_char_ordinal_default

   ENDIF

   ; compare two locale-specific chars, effectively (b-c)

   PUBLIC __lc_char_cmp_bc

   IF __crt_cfg_lc_char_cmp_bc_address

      __lc_char_cmp_bc:           jp __crt_cfg_lc_char_cmp_bc_address

   ELSE

      EXTERN __lc_char_cmp_bc_default
   
      __lc_char_cmp_bc:           jp __lc_char_cmp_bc_default

   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; unimplemented
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   PUBLIC __thread_critical_section_begin
   PUBLIC __thread_critical_section_end

   IF __CLIB_OPT_MULTITHREAD
   
      EXTERN asm_z80_push_di, asm_z80_pop_ei
   
      __thread_critical_section_begin:
      
         jp asm_z80_push_di
      
      __thread_critical_section_end:
      
         jp asm_z80_pop_ei
      
   ELSE
   
      __thread_critical_section_begin:
      __thread_critical_section_end:
   
   ENDIF

   PUBLIC __thread_context_switch
   PUBLIC __thread_block_timeout
   PUBLIC __thread_unblock

   __thread_context_switch:
   __thread_block_timeout:
   __thread_unblock:

      ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
