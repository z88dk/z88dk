;       Startup Code for Sega Master System
;
;	Haroldo O. Pinheiro February 2006
;
;	$Id: sms_crt0.asm,v 1.20 2016-07-13 22:12:25 dom Exp $
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

        defc    crt0 = 1
	INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

        EXTERN    _main           ;main() is always external to crt0 code
        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)


        
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
	call	crt0_init_bss
	ld      (exitsp),sp

	
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
	EXTERN 	closeall
	call	closeall
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
    defb (NameTableAddress/1024) |@11110001,$82
    defb (SpriteTableAddress/128)|@10000001,$85
    defb (SpriteSet/4)           |@11111011,$86
    defb $f|$f0,$87
    ;     `-------- Border palette colour (sprite palette)
    defb $00,$88
    ;     ``------- Horizontal scroll
    defb $00,$89
    ;     ``------- Vertical scroll
    defb $ff,$8a
    ;     ``------- Line interrupt spacing ($ff to disable)
_End:
	

        INCLUDE "crt0_runtime_selection.asm"

	defc __crt_org_bss = RAM_Start
        ; If we were given a model then use it
        IF DEFINED_CRT_MODEL
            defc __crt_model = CRT_MODEL
        ELSE
            defc __crt_model = 1
        ENDIF
	INCLUDE	"crt0_section.asm"



		SECTION bss_crt
fputc_vdp_offs:		defw	0	;Current character pointer
aPLibMemory_bits:	defb	0	;apLib support variable
aPLibMemory_byte:	defb	0	;apLib support variable
aPLibMemory_LWM:	defb	0	;apLib support variable
aPLibMemory_R0:		defw	0	;apLib support variable
raster_procs:		defs	16	;Raster interrupt handlers
pause_procs:		defs	16	;Pause interrupt handlers
timer:			defw	0	;This is incremented every time a VBL/HBL interrupt happens
_pause_flag:		defb	0	;This alternates between 0 and 1 every time pause is pressed
RG0SAV:			defb	0	;keeping track of VDP register values
RG1SAV:			defb	0
RG2SAV:			defb	0
RG3SAV:			defb	0
RG4SAV:			defb	0
RG5SAV:			defb	0
RG6SAV:			defb	0
RG7SAV:			defb	0







