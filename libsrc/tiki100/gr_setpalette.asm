;
;	TIKI-100 graphics routines
;	by Stefano Bodrato, Fall 2015
;
;	Edited by Frode van der Meeren
;
;   Palette is always 16 colors long, 'len' is the number
;   of colors being passed, which will be copied many times
;
; void __FASTCALL__ gr_setpalette(int len, char *palette)
;
;	Changelog:
;
;	v1.2 - FrodeM
;	   * Made sure no palette writes take place when palette register is updated
;	   * Palette register is only written to once per entry in char palette
;	   * Use address $F04D to store graphics mode instead of dedicated byte
;
;	$Id: gr_setpalette.asm,v 1.3 2016-06-10 23:01:47 dom Exp $
;

SECTION code_clib
PUBLIC gr_setpalette
PUBLIC _gr_setpalette

gr_setpalette:
_gr_setpalette:
	pop	bc
	pop	hl		; *palette
	pop	de		; len
	push	de
	push	hl
	push	bc

	ld	d,e		; Number of colours
	ld	b,0		; Current position

	ld	a,e
set_loop:
	push	af
	ld	a,(hl)
	inc	hl
	push	bc
	push	de
	push	hl
	call	do_set
	pop	hl
	pop	de
	pop	bc
	inc	b
	pop	af
	dec	a
	jr	nz,set_loop

	ret
	

;
; Writes a single palette color from a palette of a given size,
; where the palette is looping through all 16 palette entries.
; Size 2, 4 and 16 makes sense, and no other values for size
; should be used.
;
;
; Input:
; 	A = Palette
; 	B = Position
;	D = number of colours
;
.do_set
	cpl
        LD E,A
	ld	hl,$f04d
.palette_loop
        PUSH DE
        LD A,E
        DI
        OUT ($14),A             ; Palette register (prepare the color to be loaded)
        OUT ($14),A             ; Palette register (do it again to be sure)
	ld	a,(hl)
	and	$30
	add	b
	ld	d,a
	or	$80
        OUT ($0C),A             ; set graphics mode enabling graphics
        LD C,0
.wait_loop
        DEC C
        JP NZ,wait_loop         ; wait for HBLANK to get the color copied in the requested palette position
        LD A,D
        OUT ($0C),A                     ; set graphics mode
        EI
        POP DE
        LD A,B
        ADD D                   ; move to next palette position
        LD B,A
        CP 16
        JR C,palette_loop
        RET


