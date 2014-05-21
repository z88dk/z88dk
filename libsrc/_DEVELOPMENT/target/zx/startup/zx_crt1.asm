
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; zx spectrum crt
;
; #pragma output STACKPTR=address - crt sets stack pointer
;
; * stdin  = rom isr keyboard
; * stdout = fzx
; * stderr = fzx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; origin ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "zcc_opt.def"

IF !myzorg

   defc myzorg = 32768

ENDIF

org myzorg

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; global symbols ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "../crt_symbol.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt configuration ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

INCLUDE "crt_cfg.inc"
INCLUDE "../crt_cfg_default.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; bss segment - external segment declarations only ;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; No memory is occupied
; Declarations only if the segment is external

IF __crt_segment_bss_address > 0

   ; bss segment is external
   
   defc __crt_segment_bss_begin = __crt_segment_bss_address
   
   defvars __crt_segment_bss_begin
   {
      ; -- insert local crt bss segment here ------------------
      
      __sp                     ds.w 1
      
      ; -------------------------------------------------------
   }
   
   INCLUDE "../crt_segment_bss_defvars.inc"
   INCLUDE "segment_bss_defvars.inc"
   
   defvars -1
   {
      __crt_segment_bss_end
   }

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; data segment - external segment declarations only ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; No memory is occupied
; Declarations only if the segment is external

IF __crt_segment_data_address > 0

   ; data segment is external
   
   defc __crt_segment_data_begin = __crt_segment_data_address
   
   PUBLIC _fzx
   
   defvars __crt_segment_data_begin
   {
   ; -- insert local crt data segment here --------------------

      _fzx                ds.b 6
   }
   
   IF __crt_cfg_file_enable & $01
   
   defvars -1
   {
                          ds.w 1
      __CRT_FILE_STDIN    ds.b __CLIB_OPT_STDIO_FILE_EXTRA + 13
   }
   
   ENDIF
   
   IF __crt_cfg_file_enable & $02

   defvars -1
   {   
                          ds.w 1
      __CRT_FILE_STDOUT   ds.b __CLIB_OPT_STDIO_FILE_EXTRA + 13
   }
   
   ENDIF
   
   IF __crt_cfg_file_enable & $04
   
   defvars -1
   {
                          ds.w 1
      __CRT_FILE_STDERR   ds.b __CLIB_OPT_STDIO_FILE_EXTRA + 13
   }
   
   ENDIF
   
   ; ----------------------------------------------------------
   
   INCLUDE "../crt_segment_data_defvars.inc"
   INCLUDE "segment_data_defvars.inc"
   
   defvars -1
   {
      __crt_segment_data_end
   }

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; startup ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __crt_code_begin, __crt_code_end, __Exit

PUBLIC __crt_segment_bss_begin,  __crt_segment_bss_end, __crt_segment_bss_len
PUBLIC __crt_segment_data_begin, __crt_segment_data_end, __crt_segment_data_len
PUBLIC __crt_segment_data_source_begin, __crt_segment_data_source_end, __crt_segment_data_source_len

EXTERN _main, asm_cons_cls_00

__crt_code_begin:

   push iy                     ; save state required for successful
   exx                         ; return to basic
   push hl
      
   ; crt initialization
   
   INCLUDE "../crt_init.asm"

   ; save stack address for easy exit

   ld (__sp),sp                ; exit() can occur at any value of sp
   
   IF STACKPTR                 ; pragma to locate stack
   
      ld sp,STACKPTR
   
   ENDIF

   ; console initialization
   
   ld a,(__sound_bit_state)
   out ($fe),a
   call asm_cons_cls_00
      
   ; call user program
   
   call _main                  ; hl = return status
   
   ; run exit stack
   
   INCLUDE "../crt_exit.asm"
   
__Exit:

   ; close open files
   
   INCLUDE "../crt_cleanup.asm"
   
   ; exit to host
   
   ld c,l
   ld b,h                      ; bc = return status
   
   ld sp,(__sp)                ; restore original stack
   
   exx
   pop hl                      ; restore hl'
   exx
   pop iy                      ; restore iy
   
   im 1
   
   ei
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt stubs -- library functions not yet implemented ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "../crt_stub.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; data segment stored copy ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; stored copy of data segment

__crt_segment_data_source_begin:

IF __crt_cfg_segment_data & $01

   ; crt initializes data segment

   ; -- insert local crt data segment here --------------------

   _fzx_s:

      EXTERN _ff_ao_SoixanteQuatre

      defw _ff_ao_SoixanteQuatre
      defb 0, 0, 0, 0

   IF __crt_cfg_file_enable & $01
   
      IF __crt_cfg_file_enable & $02
      
         defw __CRT_FILE_STDOUT - 2
         
      ENDIF
      
      IF (__crt_cfg_file_enable & $06) = 4
      
         defw __CRT_FILE_STDERR - 2
         
      ENDIF
      
      IF (__crt_cfg_file_enable & $06) = 0
      
         defw 0
         
      ENDIF

   __CRT_FILE_STDIN_s:

      EXTERN __cons_input_kbd_A_00

      defb 195                    ; jp driver
      defw __cons_input_kbd_A_00
      defb $40                    ; open for reading
      defb $02                    ; last operation was a read
      defb 0
      defb 0
      defb 0, 2, 0, $fe, 0, 0     ; recursive mutex

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 0

         defb $81                 ; driver flags = echo on

      ENDIF
                       
      IF __CLIB_OPT_STDIO_FILE_EXTRA > 1

         defs __CLIB_OPT_STDIO_FILE_EXTRA - 1

      ENDIF

   ENDIF

   IF __crt_cfg_file_enable & $02
   
      IF __crt_cfg_file_enable & $04
      
         defw __CRT_FILE_STDERR - 2
      
      ELSE
      
         defw 0
      
      ENDIF

   __CRT_FILE_STDOUT_s:

      EXTERN __cons_output_fzx_00

      defb 195                    ; jp driver
      defw __cons_output_fzx_00
      defb $80                    ; open for writing
      defb 0
      defb 0
      defb 0
      defb 0, 2, 0, $fe, 0, 0     ; recursive mutex

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 0

         defb 0                   ; driver flags n/a

      ENDIF

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 1

         defs __CLIB_OPT_STDIO_FILE_EXTRA - 1

      ENDIF

   ENDIF

   IF __crt_cfg_file_enable & $04
   
      defw 0

   __CRT_FILE_STDERR_s:

      EXTERN __cons_output_fzx_00

      defb 195                      ; jp driver
      defw __cons_output_fzx_00
      defb $80                      ; open for writing
      defb 0
      defb 0
      defb 0
      defb 0, 2, 0, $fe, 0, 0       ; recursive mutex

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 0

         defb 0                     ; driver flags n/a

      ENDIF

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 1

         defs __CLIB_OPT_STDIO_FILE_EXTRA - 1

      ENDIF
   
   ENDIF

   ; ----------------------------------------------------------
   
   INCLUDE "../crt_segment_data_s_defb.asm"
   INCLUDE "segment_data_s_defb.asm"

ENDIF

__crt_segment_data_source_end:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; data segment - internal ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_segment_data_address = 0

   ; data segment is attached to binary
   
__crt_segment_data_begin:

   ; -- insert local crt data segment here --------------------

   PUBLIC _fzx

   _fzx:

      EXTERN _ff_ao_SoixanteQuatre

      defw _ff_ao_SoixanteQuatre
      defb 0, 0, 0, 0

   IF __crt_cfg_file_enable & $01
   
      IF __crt_cfg_file_enable & $02
      
         defw __CRT_FILE_STDOUT - 2
         
      ENDIF
      
      IF (__crt_cfg_file_enable & $06) = 4
      
         defw __CRT_FILE_STDERR - 2
         
      ENDIF
      
      IF (__crt_cfg_file_enable & $06) = 0
      
         defw 0
         
      ENDIF

   __CRT_FILE_STDIN:

      EXTERN __cons_input_kbd_A_00

      defb 195                    ; jp driver
      defw __cons_input_kbd_A_00
      defb $40                    ; open for reading
      defb $02                    ; last operation was a read
      defb 0
      defb 0
      defb 0, 2, 0, $fe, 0, 0     ; recursive mutex

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 0

         defb $81                 ; driver flags = echo on

      ENDIF
                       
      IF __CLIB_OPT_STDIO_FILE_EXTRA > 1

         defs __CLIB_OPT_STDIO_FILE_EXTRA - 1

      ENDIF

   ENDIF

   IF __crt_cfg_file_enable & $02
   
      IF __crt_cfg_file_enable & $04
      
         defw __CRT_FILE_STDERR - 2
      
      ELSE
      
         defw 0
      
      ENDIF

   __CRT_FILE_STDOUT:

      EXTERN __cons_output_fzx_00

      defb 195                    ; jp driver
      defw __cons_output_fzx_00
      defb $80                    ; open for writing
      defb 0
      defb 0
      defb 0
      defb 0, 2, 0, $fe, 0, 0     ; recursive mutex

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 0

         defb 0                   ; driver flags n/a

      ENDIF

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 1

         defs __CLIB_OPT_STDIO_FILE_EXTRA - 1

      ENDIF

   ENDIF

   IF __crt_cfg_file_enable & $04
   
      defw 0

   __CRT_FILE_STDERR:

      EXTERN __cons_output_fzx_00

      defb 195                      ; jp driver
      defw __cons_output_fzx_00
      defb $80                      ; open for writing
      defb 0
      defb 0
      defb 0
      defb 0, 2, 0, $fe, 0, 0       ; recursive mutex

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 0

         defb 0                     ; driver flags n/a

      ENDIF

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 1

         defs __CLIB_OPT_STDIO_FILE_EXTRA - 1

      ENDIF
   
   ENDIF

   ; ----------------------------------------------------------
   
   INCLUDE "../crt_segment_data_defb.asm"
   INCLUDE "segment_data_defb.asm"

__crt_segment_data_end:

ENDIF

__crt_code_end:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; bss segment - internal ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_segment_bss_address = 0

   ; bss segment is attached to the binary

__crt_segment_bss_begin:

   ; -- insert local crt bss segment here ---------------------
   
   __sp:                       defs 2
   
   ; ----------------------------------------------------------

   INCLUDE "../crt_segment_bss_defs.asm"
   INCLUDE "segment_bss_defs.asm"

__crt_segment_bss_end:

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

defc __crt_segment_bss_len = __crt_segment_bss_end - __crt_segment_bss_begin
defc __crt_segment_data_len = __crt_segment_data_end - __crt_segment_data_begin
defc __crt_segment_data_source_len = __crt_segment_data_source_end - __crt_segment_data_source_begin
