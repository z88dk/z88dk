;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt rules for yaz180 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IFDEF CRT_PHASE_CODE_COMMMON1

      defc __crt_phase_code_common1 = CRT_PHASE_CODE_COMMON1

   ELSE

      IFDEF TAR__crt_phase_code_common1

         defc __crt_phase_code_common1 = TAR__crt_phase_code_common1

      ENDIF

   ENDIF

   IFDEF CRT_ORG_DATA_COMMMON1

      defc __crt_org_data_common1 = CRT_ORG_DATA_COMMON1

   ELSE

      IFDEF TAR__crt_org_data_common1

         defc __crt_org_data_common1 = TAR__crt_org_data_common1

      ENDIF

   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; Input Terminal Settings
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IFNDEF CRT_ITERM_TERMINAL_FLAGS
      defc CRT_ITERM_TERMINAL_FLAGS = 0x03b0
   ENDIF

   ; buffer size must be available to m4 (requires special case in zcc)
	
	ifdef(`M4__CRT_ITERM_EDIT_BUFFER_SIZE',,`define(`M4__CRT_ITERM_EDIT_BUFFER_SIZE', 64)')

   IFNDEF CRT_ITERM_EDIT_BUFFER_SIZE
      defc CRT_ITERM_EDIT_BUFFER_SIZE = M4__CRT_ITERM_EDIT_BUFFER_SIZE
   ENDIF

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; Output Terminal Settings
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   IFNDEF CRT_OTERM_TERMINAL_FLAGS
      defc CRT_OTERM_TERMINAL_FLAGS = 0x2370
   ENDIF

;; end crt rules ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
