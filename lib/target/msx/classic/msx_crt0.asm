
                MODULE  msx_crt0


		defc    crt0 = 1
                INCLUDE "zcc_opt.def"

		EXTERN    _main

		PUBLIC    cleanup
		PUBLIC    l_dcal
		PUBLIC    msxbios

		defc    CONSOLE_COLUMNS = 32
		defc    CONSOLE_ROWS = 24
		defc    __CPU_CLOCK = 3580000

IF (!DEFINED_startup || (startup=1))
		INCLUDE	"target/msx/classic/ram.asm"
ENDIF

IF startup = 2
		INCLUDE	"target/msx/classic/msxdos.asm"
ENDIF

IF startup = 3
		INCLUDE	"target/msx/classic/rom.asm"
ENDIF


	SECTION		code_clib

; Safe BIOS call
msxbios:
	ld	iy,($FCC0)	; slot address of BIOS ROM
	call	001Ch		; CALSLT
	ei			; make sure interrupts are enabled
	ret


; ---------------
; MSX specific stuff
; ---------------


	SECTION		bss_crt
        PUBLIC  RG0SAV          ;keeping track of VDP register values
        PUBLIC  RG1SAV
        PUBLIC  RG2SAV
        PUBLIC  RG3SAV
        PUBLIC  RG4SAV
        PUBLIC  RG5SAV
        PUBLIC  RG6SAV
        PUBLIC  RG7SAV

RG0SAV:         defb    0       ;keeping track of VDP register values
RG1SAV:         defb    0
RG2SAV:         defb    0
RG3SAV:         defb    0
RG4SAV:         defb    0
RG5SAV:         defb    0
RG6SAV:         defb    0
RG7SAV:         defb    0

