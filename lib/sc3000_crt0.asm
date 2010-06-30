;       CRT0 stub for the SEGA SC-3000
;
;       Stefano Bodrato - Jun 2010
;
;	$Id: sc3000_crt0.asm,v 1.2 2010-06-30 13:21:38 stefano Exp $
;

	; Constants for ROM mode (-startup=2)
	
	DEFC	ROM_Start  = $0000
	DEFC	INT_Start  = $0038
	DEFC	NMI_Start  = $0066
	DEFC	CODE_Start = $0100
	DEFC	RAM_Start  = $C000
	DEFC	RAM_Length = $2000
	DEFC	Stack_Top  = $dff0


                MODULE  sc3000_crt0

;
; Initially include the zcc_opt.def file to find out lots of lovely
; information about what we should do..
;

                INCLUDE "zcc_opt.def"

; No matter what set up we have, main is always, always external to
; this file

		XREF    _main

; Some variables which are needed for both app and basic startup
		XDEF    cleanup
		XDEF    l_dcal

; Integer rnd seed
		XDEF    _std_seed

; vprintf is internal to this file so we only ever include one of the set
; of routines
		XDEF	_vfprintf

;Exit variables
		XDEF    exitsp
		XDEF    exitcount

;For stdin, stdout, stder
		XDEF    __sgoioblk
        
		XDEF	heaplast	;Near malloc heap variables
		XDEF	heapblocks

; Graphics stuff
		XDEF	pixelbyte	; Temp store for non-buffered mode
		XDEF	base_graphics
		XDEF	coords

; 1 bit sound status byte
		XDEF	snd_tick

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



; Now, getting to the real stuff now!

;--------
; Set an origin for the application (-zorg=) default to $9815 (just after a CALL in a BASIC program)
;--------

IF (startup=2)
	defc    myzorg  = ROM_Start
ELSE
	IF      !myzorg
		defc    myzorg  = $9815
	ENDIF
ENDIF
        org     myzorg

IF (startup=2)
;  ******************** ********************
;              R O M    M O D E
;  ******************** ********************
	di
	jp      start
	defm    "Small C+ SC-3000"

filler1:
	defs	(INT_Start - filler1)

int_RASTER:
	push	hl
	
	ld	a, ($BF)
	or	a
	jp	p, int_not_VBL	; Bit 7 not set
	jr	int_VBL

int_not_VBL:
	pop	hl
	reti
	
int_VBL:
	ld	hl, timer
	ld	a, (hl)
	inc	a
	ld	(hl), a
	inc	hl
	ld	a, (hl)
	adc	a, 1
	ld	(hl), a		;Increments the timer
	
	ld	hl, raster_procs
	jr	int_handler

filler2:
	defs	(NMI_Start - filler2)
int_PAUSE:
	push	hl
	
	ld	hl, _pause_flag
	ld	a, (hl)
	xor	a, 1
	ld	(hl), a
	
	ld	hl, pause_procs
	jr	int_handler	

int_handler:
	push	af
	push	bc
	push	de
int_loop:
	ld	a, (hl)
	inc	hl
	or	(hl)
	jr	z, int_done
	push	hl
	ld	a, (hl)
	dec	hl
	ld	l, (hl)
	ld	h, a
	call	call_int_handler
	pop	hl
	inc	hl
	jr	int_loop
int_done:
	pop	de
	pop	bc
	pop	af
	pop	hl
	
	ei

	reti

call_int_handler:
	jp	(hl)

;-------        
; Beginning of the actual code
;-------
filler3:
	defs   (CODE_Start - filler3)

start:
; Make room for the atexit() stack
	ld	hl,Stack_Top-64
	ld	sp,hl
; Clear static memory
	ld	hl,RAM_Start
	ld	de,RAM_Start+1
	ld	bc,RAM_Length-1
	ld	(hl),0
	ldir
ELSE
;  ******************** ********************
;           B A S I C    M O D E
;  ******************** ********************

start:
        ld      hl,0
        add     hl,sp
        ld      (start1+1),hl
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
ENDIF

;  ******************** ********************
;    BACK TO COMMON CODE FOR ROM AN BASIC
;  ******************** ********************

	ld      (exitsp),sp

IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
; Set up the std* stuff so we can be called again
	ld	hl,__sgoioblk+2
	ld	(hl),19	;stdin
	ld	hl,__sgoioblk+6
	ld	(hl),21	;stdout
	ld	hl,__sgoioblk+10
	ld	(hl),21	;stderr
ENDIF
ENDIF

IF (startup=2)
;    if ROM mode, init variables in RAM
	ld      hl,$8080
	ld      (fp_seed),hl

	xor     a
	ld      (exitcount),a
	
	call	DefaultInitialiseVDP
	
	im	1
	ei
ENDIF

; Entry to the user code
	call    _main

cleanup:
;
;       Deallocate memory which has been allocated here!
;
	push	hl
IF !DEFINED_nostreams
IF DEFINED_ANSIstdio
	LIB	closeall
	call	closeall
ENDIF
ENDIF

IF (startup=2)
endloop:
	jr	endloop
ELSE
start1:
        ld      sp,0
		ret
ENDIF


l_dcal:
        jp      (hl)


; Now, which of the vfprintf routines do we need?


_vfprintf:
IF DEFINED_floatstdio
	LIB	vfprintf_fp
	jp	vfprintf_fp
ELSE
	IF DEFINED_complexstdio
		LIB	vfprintf_comp
		jp	vfprintf_comp
	ELSE
		IF DEFINED_ministdio
			LIB	vfprintf_mini
			jp	vfprintf_mini
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

IF (startup=2)
	DEFVARS RAM_Start
	{
	__sgoioblk      	ds.b    40      ;stdio control block
	_std_seed        	ds.w    1       ;Integer seed
	exitsp          	ds.w    1       ;atexit() stack
	exitcount       	ds.b    1       ;Number of atexit() routines
	pixelbyte           ds.w    1
	base_graphics       ds.w    1
	coords              ds.w    1
	snd_tick            ds.w    1
	fp_seed             ds.w    3       ;Floating point seed (not used ATM)
	extra               ds.w    3       ;Floating point spare register
	fa                  ds.w    3       ;Floating point accumulator
	fasign              ds.b    1       ;Floating point variable
	heapblocks          ds.w    1       ;Number of free blocks
	heaplast            ds.w    1       ;Pointer to linked blocks
	fputc_vdp_offs	    ds.w	1	;Current character pointer
	aPLibMemory_bits    ds.b	1	;apLib support variable
	aPLibMemory_byte    ds.b	1	;apLib support variable
	aPLibMemory_LWM	    ds.b	1	;apLib support variable
	aPLibMemory_R0	    ds.w	1	;apLib support variable
	raster_procs	    ds.w	8	;Raster interrupt handlers
	pause_procs		ds.w	8	;Pause interrupt handlers
	timer			ds.w	1	;This is incremented every time a VBL/HBL interrupt happens
	_pause_flag		ds.b	1	;This alternates between 0 and 1 every time pause is pressed
	RG0SAV			ds.b	1	;keeping track of VDP register values
	RG1SAV			ds.b	1
	RG2SAV			ds.b	1
	RG3SAV			ds.b	1
	RG4SAV			ds.b	1
	RG5SAV			ds.b	1
	RG6SAV			ds.b	1
	RG7SAV			ds.b	1
	}

;---------------------------------
; VDP Initialization
;---------------------------------
DefaultInitialiseVDP:
    push hl
    push bc
        ld hl,_Data
        ld b,_End-_Data
        ld c,$bf
        otir
    pop bc
    pop hl
    ret

    DEFC SpriteSet          = 0       ; 0 for sprites to use tiles 0-255, 1 for 256+
    DEFC NameTableAddress   = $3800   ; must be a multiple of $800; usually $3800; fills $700 bytes (unstretched)
    DEFC SpriteTableAddress = $3f00   ; must be a multiple of $100; usually $3f00; fills $100 bytes

_Data:
    defb @00000100,$80
    ;     |||||||`- Disable synch
    ;     ||||||`-- Enable extra height modes
    ;     |||||`--- SMS mode instead of SG
    ;     ||||`---- Shift sprites left 8 pixels
    ;     |||`----- Enable line interrupts
    ;     ||`------ Blank leftmost column for scrolling
    ;     |`------- Fix top 2 rows during horizontal scrolling
    ;     `-------- Fix right 8 columns during vertical scrolling
    defb @10000100,$81
    ;      |||| |`- Zoomed sprites -> 16x16 pixels
    ;      |||| `-- Doubled sprites -> 2 tiles per sprite, 8x16
    ;      |||`---- 30 row/240 line mode
    ;      ||`----- 28 row/224 line mode
    ;      |`------ Enable VBlank interrupts
    ;      `------- Enable display
    defb (NameTableAddress/2^10) |@11110001,$82
    defb (SpriteTableAddress/2^7)|@10000001,$85
    defb (SpriteSet/2^2)         |@11111011,$86
    defb $f|$f0,$87
    ;     `-------- Border palette colour (sprite palette)
    defb $00,$88
    ;     ``------- Horizontal scroll
    defb $00,$89
    ;     ``------- Vertical scroll
    defb $ff,$8a
    ;     ``------- Line interrupt spacing ($ff to disable)
_End:

ELSE
     defm  "Small C+ SC-3000"
	 defb  0

; Now, define some values for stdin, stdout, stderr

	__sgoioblk:
	IF DEFINED_ANSIstdio
		INCLUDE	"stdio_fp.asm"
	ELSE
			defw    -11,-12,-10
	ENDIF


	;Seed for integer rand() routines
	_std_seed:      defw    0

	;Atexit routine
	exitsp:	defw    0
	exitcount:	defb    0

	; Heap stuff
	heaplast:	defw	0
	heapblocks:	defw	0


	; mem stuff
	pixelbyte:	defb	0
	base_graphics:	defw	0
	coords:		defw	0
	snd_tick:	defb	0
	
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
	
	;All the float stuff is kept in a different file...for ease of altering!
	;It will eventually be integrated into the library
	;
	;Here we have a minor (minor!) problem, we've no idea if we need the
	;float package if this is separated from main (we had this problem before
	;but it wasn't critical..so, now we will have to read in a file from
	;the directory (this will be produced by zcc) which tells us if we need
	;the floatpackage, and if so what it is..kludgey, but it might just work!
	;
	;Brainwave time! The zcc_opt file could actually be written by the
	;compiler as it goes through the modules, appending as necessary - this
	;way we only include the package if we *really* need it!

	IF NEED_floatpack
			INCLUDE         "float.asm"

	;seed for random number generator - not used yet..
	fp_seed:        defb    $80,$80,0,0,0,0
	;Floating point registers...
	extra:          defs    6
	fa:             defs    6
	fasign:         defb    0
	ENDIF

ENDIF

