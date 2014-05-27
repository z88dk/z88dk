
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CPM crt0 for new library
;
; #pragma output noprotectmsdos - strip the MS-DOS protection header
;
; * stdin  = bdos kbd
; * stdout = bdos cons
; * stderr = bdos cons
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; origin ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "zcc_opt.def"

org $100

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
      
      __sp                            ds.w 1
      __null_string                   ds.b 1
      __stdin_edit_buf                ds.b __crt_cfg_edit_buflen
      
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
   
   defvars __crt_segment_data_begin
   {
   ; -- insert local crt data segment here --------------------
   }
   
   IF __crt_cfg_file_enable & $01
   
   defvars -1
   {
                                      ds.w 1
      __CRT_FILE_STDIN                ds.b __CLIB_OPT_STDIO_FILE_EXTRA + 13
      __stdin_terminal_state_L1       ds.b 7
   }
   
   ENDIF
   
   IF __crt_cfg_file_enable & $02

   defvars -1
   {   
                                      ds.w 1
      __CRT_FILE_STDOUT               ds.b __CLIB_OPT_STDIO_FILE_EXTRA + 13
   }
   
   ENDIF
   
   IF __crt_cfg_file_enable & $04
   
   defvars -1
   {
                                      ds.w 1
      __CRT_FILE_STDERR               ds.b __CLIB_OPT_STDIO_FILE_EXTRA + 13
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

EXTERN _main

__crt_code_begin:

IF !DEFINED_noprotectmsdos

	defb	$eb,$04		;DOS protection... JMPS LABE
	ex	    de,hl
	jp	    begin
	defb	$b4,$09		;DOS protection... MOV AH,9
	defb	$ba
	defw	dosmessage	;DOS protection... MOV DX,OFFSET dosmessage
	defb	$cd,$21		;DOS protection... INT 21h.
	defb	$cd,$20		;DOS protection... INT 20h.

dosmessage:

	defm	"This program is for a CP/M system."
	defb	13,10,'$'

begin:

ENDIF

   ; crt initialization
   
   INCLUDE "../crt_init.asm"

   ld       (__sp),sp

   ; Command line arguments - push points to argv[n] onto the stack

	ld	    hl,0	;NULL pointer at end, just in case
	push	hl
	ld	    hl,$80
	ld	    a,(hl)
	ld	    b,0
	and	    a
	jr	    z,argv_done
	ld	    c,a
	add	    hl,bc	;now points to the end
    ; Try to find the end of the arguments
argv_loop_1:
	ld	    a,(hl)
	cp	    ' '
	jr	    nz,argv_loop_2
	ld	    (hl),0
	dec	    hl
	dec	    c
	jr	    nz,argv_loop_1
; We've located the end of the last argument, try to find the start
argv_loop_2:
	ld	    a,(hl)
	cp	    ' '
	jr	    nz,argv_loop_3
	inc	    hl

; TODO: Redirection (when we have file i/o)

	push	hl
	inc	    b
	dec	    hl

; skip extra blanks
argv_zloop:
	ld	    (hl),0
	dec	    c
	jr	    z,argv_done
	dec	    hl
	ld	    a,(hl)
	cp	    ' '
	jr	    z,argv_zloop
	inc     c
	inc     hl

argv_loop_3:
	dec	    hl
	dec	    c
	jr	    nz,argv_loop_2

argv_done:
	ld	    hl,__null_string	;name of program (NULL)
	push	hl
	inc	    b
	ld	    hl,0
	add	    hl,sp	;address of argv
	ld	    c,b
	ld	    b,0

   ; call user program

    push    bc  ; argc
    push    hl  ; argv
    
    call    _main                  ; hl holds return status
    
    pop     bc
    pop     bc

   ; run exit stack
   
   INCLUDE "../crt_exit.asm"
   
__Exit:

   ; close open files
   
   INCLUDE "../crt_cleanup.asm"

   ; exit to host

    ld      c,l
    ld      b,h                      ; return status to basic

    ld      sp,(__sp)
    jp      0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; crt stubs -- library functions not yet implemented ;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "../crt_stub.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; data segment stored copy ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; stored copy of data segment

__crt_segment_data_source_begin:

IF (__crt_cfg_segment_data & $03) = 1

   ; crt initializes data segment from uncompressed stored copy

   ; -- insert local crt data segment here --------------------

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

      EXTERN __cons_input_kbd_bdos_L1

      defb 195                    ; jp driver
      defw __cons_input_kbd_bdos_L1
      defb $40                    ; open for reading
      defb $02                    ; last operation was a read
      defb 0
      defb 0
      defb 0, 2, 0, $fe, 0, 0     ; recursive mutex

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 0

         defb $b1                 ; driver flags = echo | line | cook

      ENDIF
                       
      IF __CLIB_OPT_STDIO_FILE_EXTRA > 2
      
         defw __stdin_terminal_state_L1
         defs __CLIB_OPT_STDIO_FILE_EXTRA - 2

      ENDIF

      __stdin_terminal_state_L1_s:
      
         defw __CRT_FILE_STDOUT
         defw __stdin_edit_buf
         defw __stdin_edit_buf
         defb __crt_cfg_edit_buflen

   ENDIF

   IF __crt_cfg_file_enable & $02
   
      IF __crt_cfg_file_enable & $04
      
         defw __CRT_FILE_STDERR - 2
      
      ELSE
      
         defw 0
      
      ENDIF

   __CRT_FILE_STDOUT_s:

      EXTERN __cons_output_bdos_L1

      defb 195                    ; jp driver
      defw __cons_output_bdos_L1
      defb $80                    ; open for writing
      defb 0
      defb 0
      defb 0
      defb 0, 2, 0, $fe, 0, 0     ; recursive mutex

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 0

         defb $12                 ; driver flags = cook

      ENDIF

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 2

         defw __stdin_terminal_state_L1
         defs __CLIB_OPT_STDIO_FILE_EXTRA - 2

      ENDIF

   ENDIF

   IF __crt_cfg_file_enable & $04
   
      defw 0

   __CRT_FILE_STDERR_s:

      EXTERN __cons_output_bdos_L1

      defb 195                      ; jp driver
      defw __cons_output_bdos_L1
      defb $80                      ; open for writing
      defb 0
      defb 0
      defb 0
      defb 0, 2, 0, $fe, 0, 0       ; recursive mutex

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 0

         defb $12                   ; driver flags = cook

      ENDIF

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 1

         defs __CLIB_OPT_STDIO_FILE_EXTRA - 1

      ENDIF
   
   ENDIF

   ; ----------------------------------------------------------
   
   INCLUDE "../crt_segment_data_s_defb.asm"
   INCLUDE "segment_data_s_defb.asm"

ENDIF

IF (__crt_cfg_segment_data & $03) = 3

   ; crt initializes data segment from compressed stored copy
   
   BINARY "segment_data_s.bin.zx7"

ENDIF

__crt_segment_data_source_end:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; data segment - internal ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_segment_data_address = 0

   ; data segment is attached to binary
   
__crt_segment_data_begin:

   ; -- insert local crt data segment here --------------------

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

      EXTERN __cons_input_kbd_bdos_L1

      defb 195                    ; jp driver
      defw __cons_input_kbd_bdos_L1
      defb $40                    ; open for reading
      defb $02                    ; last operation was a read
      defb 0
      defb 0
      defb 0, 2, 0, $fe, 0, 0     ; recursive mutex

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 0

         defb $b1                 ; driver flags = echo | line | cook

      ENDIF
                       
      IF __CLIB_OPT_STDIO_FILE_EXTRA > 2
      
         defw __stdin_terminal_state_L1
         defs __CLIB_OPT_STDIO_FILE_EXTRA - 2

      ENDIF
      
      __stdin_terminal_state_L1:
      
         defw __CRT_FILE_STDOUT
         defw __stdin_edit_buf
         defw __stdin_edit_buf
         defb __crt_cfg_edit_buflen

   ENDIF

   IF __crt_cfg_file_enable & $02
   
      IF __crt_cfg_file_enable & $04
      
         defw __CRT_FILE_STDERR - 2
      
      ELSE
      
         defw 0
      
      ENDIF

   __CRT_FILE_STDOUT:

      EXTERN __cons_output_bdos_L1

      defb 195                    ; jp driver
      defw __cons_output_bdos_L1
      defb $80                    ; open for writing
      defb 0
      defb 0
      defb 0
      defb 0, 2, 0, $fe, 0, 0     ; recursive mutex

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 0

         defb $12                 ; driver flags = cook

      ENDIF

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 2

         defw __stdin_terminal_state_L1
         defs __CLIB_OPT_STDIO_FILE_EXTRA - 2

      ENDIF

   ENDIF

   IF __crt_cfg_file_enable & $04
   
      defw 0

   __CRT_FILE_STDERR:

      EXTERN __cons_output_bdos_L1

      defb 195                      ; jp driver
      defw __cons_output_bdos_L1
      defb $80                      ; open for writing
      defb 0
      defb 0
      defb 0
      defb 0, 2, 0, $fe, 0, 0       ; recursive mutex

      IF __CLIB_OPT_STDIO_FILE_EXTRA > 0

         defb $12                   ; driver flags = cook

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
   __null_string:              defs 1
   __stdin_edit_buf:           defs __crt_cfg_edit_buflen
   
   ; ----------------------------------------------------------

   INCLUDE "../crt_segment_bss_defs.asm"
   INCLUDE "segment_bss_defs.asm"

__crt_segment_bss_end:

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

defc __crt_segment_bss_len = __crt_segment_bss_end - __crt_segment_bss_begin
defc __crt_segment_data_len = __crt_segment_data_end - __crt_segment_data_begin
defc __crt_segment_data_source_len = __crt_segment_data_source_end - __crt_segment_data_source_begin
