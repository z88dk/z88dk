;       Memotech MTX CRT0 stub
;
;       $Id: mtx_crt0.asm,v 1.1 2011-05-09 14:31:38 stefano Exp $
;


        MODULE  mtx_crt0

        
;--------
; Include zcc_opt.def to find out some info
;--------
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        XREF    _main           ; main() is always external to crt0 code

        XDEF    cleanup         ; jp'd to by exit()
        XDEF    l_dcal          ; jp(hl)


        XDEF    _vfprintf       ; jp to the printf() core

        XDEF    exitsp          ; atexit() variables
        XDEF    exitcount

        XDEF    heaplast        ; Near malloc heap variables
        XDEF    heapblocks

        XDEF    __sgoioblk      ; stdio info block

; Graphics stuff
        XDEF    pixelbyte	; Temp store for non-buffered mode
        XDEF    base_graphics   ; Graphical variables
        XDEF    coords          ; Current xy position

; 1 bit sound status byte
        XDEF    snd_tick        ; Sound variable

; SEGA and MSX specific
		XDEF	msxbios
		XDEF	fputc_vdp_offs	;Current character pointer
			
		XDEF	aPLibMemory_bits;apLib support variable
		XDEF	aPLibMemory_byte;apLib support variable
		XDEF	aPLibMemory_LWM	;apLib support variable
		XDEF	aPLibMemory_R0	;apLib support variable

		XDEF	raster_procs	;Raster interrupt handlers
		XDEF	pause_procs	;Pause interrupt handlers

		XDEF	timer		;This is incremented every time a VBL/HBL interrupt happens
		XDEF	_pause_flag	;This alternates between 0 and 1 every time pause is pressed

		XDEF	RG0SAV		;keeping track of VDP register values
		XDEF	RG1SAV
		XDEF	RG2SAV
		XDEF	RG3SAV
		XDEF	RG4SAV
		XDEF	RG5SAV
		XDEF	RG6SAV
		XDEF	RG7SAV       


;--------
; Set an origin for the application (-zorg=) default to 32768
;--------

        IF !myzorg
            IF (startup=2)                 ; ROM ?
                defc    myzorg  = 16384+19
            ELSE
                defc    myzorg  = 32768+19
            ENDIF
        ENDIF


        org     myzorg


start:

        ld      hl,-64
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp


IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
; Set up the std* stuff so we can be called again
        ld      hl,__sgoioblk+2
        ld      (hl),19 ;stdin
        ld      hl,__sgoioblk+6
        ld      (hl),21 ;stdout
        ld      hl,__sgoioblk+10
        ld      (hl),21 ;stderr
ENDIF
ENDIF

        call    _main           ; Call user program
cleanup:
;
;       Deallocate memory which has been allocated here!
;
        push    hl				; return code

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
        LIB     closeall
        call    closeall
ENDIF
ENDIF


cleanup_exit:

        pop     bc				; return code (still not sure it is teh right one !)

start1: ld      sp,0            ;Restore stack to entry value
        ret


l_dcal: jp      (hl)            ;Used for function pointer calls


;---------------------------------
; Select which printf core we want
;---------------------------------
_vfprintf:
IF DEFINED_floatstdio
        LIB     vfprintf_fp
        jp      vfprintf_fp
ELSE
        IF DEFINED_complexstdio
                LIB     vfprintf_comp
                jp      vfprintf_comp
        ELSE
                IF DEFINED_ministdio
                        LIB     vfprintf_mini
                        jp      vfprintf_mini
                ENDIF
        ENDIF
ENDIF


; ---------------
; MSX specific stuff
; ---------------

; Safe BIOS call
msxbios:
	push	ix
	ret

;---------------------------------------------------------------------------

coords:         defw    0       ; Current graphics xy coordinates
base_graphics:  defw    0       ; Address of the Graphics map
pixelbyte:      defb	0

; imported form the pre-existing Sega Master System libs
fputc_vdp_offs:		defw	0	;Current character pointer
aPLibMemory_bits:	defb	0	;apLib support variable
aPLibMemory_byte:	defb	0	;apLib support variable
aPLibMemory_LWM:	defb	0	;apLib support variable
aPLibMemory_R0:		defw	0	;apLib support variable
raster_procs:		defw	0	;Raster interrupt handlers
pause_procs:		defs	8	;Pause interrupt handlers
timer:				defw	0	;This is incremented every time a VBL/HBL interrupt happens
_pause_flag:		defb	0	;This alternates between 0 and 1 every time pause is pressed

RG0SAV:		defb	0	;keeping track of VDP register values
RG1SAV:		defb	0
RG2SAV:		defb	0
RG3SAV:		defb	0
RG4SAV:		defb	0
RG5SAV:		defb	0
RG6SAV:		defb	0
RG7SAV:		defb	0


IF !DEFINED_HAVESEED
                XDEF    _std_seed        ;Integer rand() seed
_std_seed:      defw    0       ; Seed for integer rand() routines
ENDIF

exitsp:         defw    0       ; Address of where the atexit() stack is
exitcount:      defb    0       ; How many routines on the atexit() stack


heaplast:       defw    0       ; Address of last block on heap
heapblocks:     defw    0       ; Number of blocks


IF DEFINED_NEED1bitsound
snd_tick:       defb    0       ; Sound variable
ENDIF


; ZXMMC SD/MMC interface
IF DEFINED_NEED_ZXMMC
	XDEF card_select
card_select:    defb    0    ; Currently selected MMC/SD slot for ZXMMC
ENDIF


;-----------
; Define the stdin/out/err area. For the z88 we have two models - the
; classic (kludgey) one and "ANSI" model
;-----------
__sgoioblk:
IF DEFINED_ANSIstdio
       INCLUDE "stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF


;-----------------------
; Floating point support
;-----------------------
IF NEED_floatpack
        INCLUDE         "float.asm"
fp_seed:        defb    $80,$80,0,0,0,0 ;FP seed (unused ATM)
extra:          defs    6               ;FP register
fa:             defs    6               ;FP Accumulator
fasign:         defb    0               ;FP register

ENDIF

;---------------------------------------------------------------------------

                defm    "Small C+ MTX"   ;Unnecessary file signature
                defb    0

