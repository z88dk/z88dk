;       Startup Code for Sega Master System
;
;	Haroldo O. Pinheiro February 2006
;
;	$Id: sms_crt0.asm,v 1.6 2010-07-13 06:16:53 stefano Exp $
;

	DEFC	ROM_Start  = $0000
	DEFC	INT_Start  = $0038
	DEFC	NMI_Start  = $0066
	DEFC	CODE_Start = $0100
	DEFC	RAM_Start  = $C000
	DEFC	RAM_Length = $2000
	DEFC	Stack_Top  = $dff0

	MODULE  sms_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

	INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

        XREF    _main           ;main() is always external to crt0 code
        XDEF    cleanup         ;jp'd to by exit()
        XDEF    l_dcal          ;jp(hl)

        XDEF    _std_seed       ;Integer rand() seed

        XDEF    exitsp          ;Pointer to atexit() stack
        XDEF    exitcount       ;Number of atexit() functions registered

        XDEF    __sgoioblk      ;std* control block

        XDEF    heaplast        ;Near malloc heap variables
        XDEF    heapblocks      ;

        XDEF    _vfprintf       ;jp to printf() core routine
        
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

	org    ROM_Start

	jp	start
	
	defm    "Sega Master System - Small C+"
	
;-------        
; Interrupt handlers
;-------
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

	ld      hl,$8080
	ld      (fp_seed),hl
	xor     a
	ld      (exitcount),a
	
	call	DefaultInitialiseVDP
	
	im	1
	ei

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

endloop:
	jr	endloop
l_dcal:
	jp      (hl)
	
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
	

;---------------------------------
; Select which printf core we want
;---------------------------------
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

; Static variables kept in safe workspace

IF !DEFINED_sysdefvarsaddr
		defc sysdefvarsaddr = RAM_Start+1024
ENDIF

DEFVARS RAM_Start
{
__sgoioblk      	ds.b    40      ;stdio control block
_std_seed        	ds.w    1       ;Integer seed
exitsp          	ds.w    1       ;atexit() stack
exitcount       	ds.b    1       ;Number of atexit() routines
fp_seed         	ds.w    3       ;Floating point seed (not used ATM)
extra           	ds.w    3       ;Floating point spare register
fa              	ds.w    3       ;Floating point accumulator
fasign          	ds.b    1       ;Floating point variable
heapblocks      	ds.w    1       ;Number of free blocks
heaplast        	ds.w    1       ;Pointer to linked blocks
fputc_vdp_offs		ds.w	1	;Current character pointer
aPLibMemory_bits	ds.b	1	;apLib support variable
aPLibMemory_byte	ds.b	1	;apLib support variable
aPLibMemory_LWM		ds.b	1	;apLib support variable
aPLibMemory_R0		ds.w	1	;apLib support variable
raster_procs		ds.w	8	;Raster interrupt handlers
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

IF !DEFINED_defvarsaddr
		defc defvarsaddr = RAM_Start+1024+256
ENDIF

DEFVARS defvarsaddr
{
dummydummy        ds.b    1 
}


;--------
; Now, include the math routines if needed..
;--------
IF NEED_floatpack
;        INCLUDE "float.asm"
ENDIF
