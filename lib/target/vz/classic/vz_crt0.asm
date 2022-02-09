;       Startup for VZ200/300
;
;       Stefano Bodrato - Apr. 2000
;
;       If an error occurs eg break we just drop back to BASIC
;
;       $Id: vz_crt0.asm,v 1.27 2016-07-15 21:03:25 dom Exp $
;



                MODULE  vz_crt0

;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


        IF      !DEFINED_CRT_ORG_CODE
            IF (startup=3)
		defc    CRT_ORG_CODE  = 32768  ; clean binary block
            ELSE
		IF (startup=2)
			defc    CRT_ORG_CODE  = $7ae9	; BASIC startup mode
		ELSE
			defc    CRT_ORG_CODE  = $7b00  ; Direct M/C mode
                ENDIF
            ENDIF
        ENDIF

        defc    CONSOLE_ROWS = 16
        defc    CONSOLE_COLUMNS = 32

; Now, getting to the real stuff now!

	defc	TAR__no_ansifont = 1
        defc    TAR__clib_exit_stack_size = 32
        defc    TAR__register_sp = -1
	defc	__CPU_CLOCK = 3800000
        INCLUDE "crt/classic/crt_rules.inc"


	org     CRT_ORG_CODE-24

IF (startup=3)
;  STARTUP=3 -> plain binary block

ELSE

  defb  $20,$20,0,0
  defm  "z80.mc"
  defb  0,0,0,0,0,0,0,0,0,0,0
  
IF (startup=2)
  ; BASIC startup mode
  defb $f0
ELSE
  ; native M/C startup mode
  defb $f1
ENDIF

  defw CRT_ORG_CODE

IF (startup=2)
  defw $7b04
  defw 1
  defb $B1              ;POKE
  defm " 30862,18:"
  defb $B1              ;POKE
  defm " 30863,123"
  defb 0                ; this block is 27 bytes long
  
  defw $7b0f
  defw 2
  defb $b2              ; PRINT
  defb ' '
  defb $c1              ; USR
  defm "(0)"
  defb 0                ; this block is 11 bytes long
  
  defw 0
  defb 4
  
; Header ends here: 65 bytes
ENDIF

ENDIF

start:
    ld      (__restore_sp_onexit+1),sp
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ld      (exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF


        call    _main
cleanup:
        push    hl
        call    crt0_exit

        pop     bc
__restore_sp_onexit:
        ld      sp,0
        jp      1A19h

l_dcal:
        jp      (hl)



        INCLUDE "crt/classic/crt_runtime_selection.asm"

	INCLUDE "crt/classic/crt_section.asm"


	SECTION	code_crt_init
	ld	hl,$7000
	ld	(base_graphics),hl


