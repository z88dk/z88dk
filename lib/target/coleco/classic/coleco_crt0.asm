;
;	Startup for Colecovision
;
;	1k of memory 

	module	coleco_crt0 


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
	PUBLIC	  msxbios
	EXTERN	  msx_set_mode

	defc	CONSOLE_COLUMNS = 32
	defc	CONSOLE_ROWS = 24

	defc	CRT_ORG_BSS = 0x7000	
	defc	CRT_ORG_CODE = 0x8000

        defc    TAR__fputc_cons_generic = 1
        defc    TAR__no_ansifont = 1
        defc    TAR__clib_exit_stack_size = 0
        defc    TAR__register_sp = 0x7400
	defc	CRT_KEY_DEL = 127
	defc	__CPU_CLOCK = 3579545
        INCLUDE "crt/classic/crt_rules.inc"

	org	  CRT_ORG_CODE

	defb	0x55, 0xaa	;Title screen + 12 second delay, swap to not slip it
	defw	0		;Sprite name table for BIOS
	defw	0		;Sprite order table for BIOS
	defw	0		;Buffer for BIOS
	defw	0		;Controller map for bios
	defw	program		;Where to start execution from
	jp	restart08
	jp	restart10
	jp	restart18
	jp	restart20
	jp	restart28
	jp	restart30
	jp	mask_int	;Maskable interrupt
	jp	nmi_int		;NMI
	defm	" / / "		;TODO: Make it customisable
	

; Restart routines, nothing sorted yet
restart08:
restart10:
restart18:
restart20:
restart28:
restart30:
	ret

program:
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call    crt0_init_bss
	ld	(exitsp),sp
	ld	hl,2
	call	msx_set_mode
	im	1
    	ei
; Optional definition for auto MALLOC init
; it assumes we have free space between the end of
; the compiled program and the stack pointer
IF DEFINED_USING_amalloc
    INCLUDE "crt/classic/crt_init_amalloc.asm"
ENDIF
	call	_main
cleanup:
	rst	0		;Restart when main finishes



nmi_int:
	push	af
	push	hl
	ld	hl,pause_procs
	call	int_handler
	pop	hl
	pop	af
	retn

mask_int:
	push	af
	push	hl
	; Flow into int_VBL
        INCLUDE "crt/classic/tms9118/interrupt_handler.asm"

; Safe BIOS call
msxbios:
        push    ix
        ret


l_dcal: jp      (hl)            ;Used for function pointer calls

	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	defc	__crt_org_bss = CRT_ORG_BSS
        IF DEFINED_CRT_MODEL
            defc __crt_model = CRT_MODEL
        ENDIF
	INCLUDE	"crt/classic/crt_section.asm"

        SECTION bss_crt


        PUBLIC  raster_procs    ;Raster interrupt handlers
        PUBLIC  pause_procs     ;Pause interrupt handlers

        PUBLIC  timer           ;This is incremented every time a VBL/HBL interrupt happens
        PUBLIC  _pause_flag     ;This alternates between 0 and 1 every time pause is pressed

        PUBLIC  RG0SAV          ;keeping track of VDP register values
        PUBLIC  RG1SAV
        PUBLIC  RG2SAV
        PUBLIC  RG3SAV
        PUBLIC  RG4SAV
        PUBLIC  RG5SAV
        PUBLIC  RG6SAV
        PUBLIC  RG7SAV

raster_procs:           defw    0       ;Raster interrupt handlers
pause_procs:            defs    8       ;Pause interrupt handlers
timer:                          defw    0       ;This is incremented every time a VBL/HBL interrupt happens
_pause_flag:            defb    0       ;This alternates between 0 and 1 every time pause is pressed

RG0SAV:         defb    0       ;keeping track of VDP register values
RG1SAV:         defb    0
RG2SAV:         defb    0
RG3SAV:         defb    0
RG4SAV:         defb    0
RG5SAV:         defb    0
RG6SAV:         defb    0
RG7SAV:         defb    0
