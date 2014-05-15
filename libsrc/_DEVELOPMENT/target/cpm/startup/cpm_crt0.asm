; CPM crt0 for new library
;
;	#pragma output noprotectmsdos - strip the MS-DOS protection header


;; origin ;;;;;;;;;;;;;;;;;;;;;

INCLUDE "zcc_opt.def"
INCLUDE "clib_cfg.asm"

org $100

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC start
PUBLIC __Exit

EXTERN _main

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "../crt_defs.inc"      ; crt defines

;; crt configuration ;;;;;;;;;;

defc __heap_sz = 2048          ; malloc's heap, eliminate if not required
defc __qtbl_sz = 6             ; balloc's qtable, eliminate if not required

defc __exit_stack_sz      = 6  ; set to 0 if not required, default is 32
defc __quickexit_stack_sz = 6  ; set to 0 if not required, default is 32

defc __HAVE_FILE_STDIN    = 1  ; set to 0 if stdin not available
defc __HAVE_FILE_STDOUT   = 1  ; set to 0 if stdout not available
defc __HAVE_FILE_STDERR   = 1  ; set to 0 if stderr not available

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

start:
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
   ld       (__sp),sp


   INCLUDE "../crt_init.asm"   ; intialize crt state

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

   INCLUDE "../crt_exit.asm"   ; run exit stack
   
__Exit:

   INCLUDE "../crt_cleanup.asm"  ; close files 

    ld      c,l
    ld      b,h                      ; return status to basic

    ld      sp,(__sp)
    jp      0
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "../crt_vars.asm"      ; crt variable declarations
INCLUDE "../crt_stubs.asm"     ; crt stubs for unimplemented lib functions

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__null_string:

   defb 0


   defw 0
   
__FILE_STDIN:
   
   defb 195                    ; jp driver
   defw __bdoskbd_driver
   defb $40                    ; open for reading
   defb $02                    ; last op was read, to skip auto-flush
   defb 0
   defb 0
   defs 6                      ; mutex

   IF __CLIB_OPT_STDIO_FILE_EXTRA > 0
      defb $81                 ; driver flags = echo on
   ENDIF
   
   IF __CLIB_OPT_STDIO_FILE_EXTRA > 1
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 1
   ENDIF


   defw 0
   
__FILE_STDOUT:

   defb 195                    ; jp driver
   defw __bdoscons_driver
   defb $80                    ; open for writing
   defb 0
   defb 0
   defb 0
   defs 6                      ; mutex

   IF __CLIB_OPT_STDIO_FILE_EXTRA > 0
      defb 0                   ; driver flags n/a
   ENDIF
   
   IF __CLIB_OPT_STDIO_FILE_EXTRA > 1
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 1
   ENDIF


   defw 0
   
__FILE_STDERR:

   ; separate from stdout allows output
   ; even when stdout is in an error state

   defb 195                    ; jp driver
   defw __bdoscons_driver
   defb $80                    ; open for writing
   defb 0
   defb 0
   defb 0
   defs 6                      ; mutex

   IF __CLIB_OPT_STDIO_FILE_EXTRA > 0
      defb 0                   ; driver flags n/a
   ENDIF
   
   IF __CLIB_OPT_STDIO_FILE_EXTRA > 1
      defs __CLIB_OPT_STDIO_FILE_EXTRA - 1
   ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "driver/__bdoscons_driver.asm"     ; input/output driver
INCLUDE "driver/__bdoskbd_driver.asm"     ; input/output driver
