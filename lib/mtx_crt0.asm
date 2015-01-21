;       Memotech MTX CRT0 stub
;
;       $Id: mtx_crt0.asm,v 1.6 2015-01-21 07:05:00 stefano Exp $
;


        MODULE  mtx_crt0

        
;--------
; Include zcc_opt.def to find out some info
;--------
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ; main() is always external to crt0 code

        PUBLIC    cleanup         ; jp'd to by exit()
        PUBLIC    l_dcal          ; jp(hl)


        PUBLIC    _vfprintf       ; jp to the printf() core

        PUBLIC    exitsp          ; atexit() variables
        PUBLIC    exitcount

        PUBLIC    heaplast        ; Near malloc heap variables
        PUBLIC    heapblocks

        PUBLIC    __sgoioblk      ; stdio info block

; Graphics stuff
        PUBLIC    pixelbyte	; Temp store for non-buffered mode
        PUBLIC    base_graphics   ; Graphical variables
        PUBLIC    coords          ; Current xy position

; 1 bit sound status byte
        PUBLIC    snd_tick        ; Sound variable
        PUBLIC	bit_irqstatus	; current irq status when DI is necessary

; SEGA and MSX specific
		PUBLIC	msxbios
		PUBLIC	fputc_vdp_offs	;Current character pointer
			
		PUBLIC	aPLibMemory_bits;apLib support variable
		PUBLIC	aPLibMemory_byte;apLib support variable
		PUBLIC	aPLibMemory_LWM	;apLib support variable
		PUBLIC	aPLibMemory_R0	;apLib support variable

		PUBLIC	raster_procs	;Raster interrupt handlers
		PUBLIC	pause_procs	;Pause interrupt handlers

		PUBLIC	timer		;This is incremented every time a VBL/HBL interrupt happens
		PUBLIC	_pause_flag	;This alternates between 0 and 1 every time pause is pressed

		PUBLIC	RG0SAV		;keeping track of VDP register values
		PUBLIC	RG1SAV
		PUBLIC	RG2SAV
		PUBLIC	RG3SAV
		PUBLIC	RG4SAV
		PUBLIC	RG5SAV
		PUBLIC	RG6SAV
		PUBLIC	RG7SAV       


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

        ld      (start1+1),sp   ; Save entry stack

        ld      hl,-64
        add     hl,sp
        ld      sp,hl

        ld      (exitsp),sp


; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "amalloc.def"
	ENDIF

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
        EXTERN     closeall
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
        EXTERN     vfprintf_fp
        jp      vfprintf_fp
ELSE
        IF DEFINED_complexstdio
                EXTERN     vfprintf_comp
                jp      vfprintf_comp
        ELSE
                IF DEFINED_ministdio
                        EXTERN     vfprintf_mini
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
                PUBLIC    _std_seed        ;Integer rand() seed
_std_seed:      defw    0       ; Seed for integer rand() routines
ENDIF

exitsp:         defw    0       ; Address of where the atexit() stack is
exitcount:      defb    0       ; How many routines on the atexit() stack


heaplast:       defw    0       ; Address of last block on heap
heapblocks:     defw    0       ; Number of blocks

IF DEFINED_USING_amalloc
EXTERN ASMTAIL
PUBLIC _heap
; The heap pointer will be wiped at startup,
; but first its value (based on ASMTAIL)
; will be kept for sbrk() to setup the malloc area
_heap:
                defw ASMTAIL	; Location of the last program byte
                defw 0
ENDIF

IF DEFINED_NEED1bitsound
snd_tick:       defb	0	; Sound variable
bit_irqstatus:	defw	0
ENDIF


; ZXMMC SD/MMC interface
IF DEFINED_NEED_ZXMMC
	PUBLIC card_select
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

