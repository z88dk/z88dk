
	MODULE	m5_crt0

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

        EXTERN    _main

        PUBLIC    cleanup
        PUBLIC    l_dcal



        PUBLIC  msxbios

	; Always use the generic console unless overridden
        defc    TAR__fputc_cons_generic = 1
        defc    CONSOLE_COLUMNS = 32
        defc    CONSOLE_ROWS = 24
        defc    __CPU_CLOCK = 3580000
	defc	CRT_KEY_DEL = 12
	INCLUDE	"crt/classic/crt_rules.inc"

IF startup = 2
	INCLUDE	"target/m5/classic/rom.asm"
ELSE
	INCLUDE "target/m5/classic/ram.asm"
ENDIF


l_dcal:
        jp      (hl)


        INCLUDE "crt/classic/crt_runtime_selection.asm"

; ---------------
; MSX specific stuff
; ---------------
; Safe BIOS call
msxbios:
        push    ix
        ret


        INCLUDE         "crt/classic/crt_section.asm"


        SECTION         bss_crt
        PUBLIC  raster_procs    ;Raster interrupt handlers
        PUBLIC  pause_procs     ;Pause interrupt handlers

        PUBLIC  timer           ;This is incremented every time a VBL/HBL interrupt happens
        PUBLIC  _pause_flag     ;This alternates between 0 and 1 every time pause is pressed

        PUBLIC  RG0SAV          ;keeping track of VDP register values
        PUBLIC  RG1SAV
        PUBLIC  RG2SAV
        PUBLIC  RG5SAV
        PUBLIC  RG6SAV
        PUBLIC  RG7SAV

raster_procs:           defw    0       ;Raster interrupt handlers
pause_procs:            defs    8       ;Pause interrupt handlers
timer:                  defw    0       ;This is incremented every time a VBL/HBL interrupt happens
_pause_flag:            defb    0       ;This alternates between 0 and 1 every time pause is pressed
RG0SAV:			defb    0       ;keeping track of VDP register values
RG1SAV:			defb    0
RG2SAV:			defb    0
RG3SAV:			defb    0
RG4SAV:			defb    0
RG5SAV:			defb    0
RG6SAV:			defb    0
RG7SAV:			defb    0

