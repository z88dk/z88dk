;
; 	ANSI Video handling for the gencon
;
; 	Text Attributes
;	m - Set Graphic Rendition

	MODULE __gencon_ansi_attr
        SECTION code_clib
	PUBLIC	__gencon_ansi_attr

	EXTERN  generic_console_flags
	EXTERN  generic_console_set_attribute
	EXTERN  generic_console_set_ink
	EXTERN  generic_console_set_paper

        SECTION code_clib

; 0 = reset all attributes
; 1 = bold on
; 2 = dim
; 4 = underline
; 5 = blink on
; 7 = reverse on
; 8 = invisible (dim again?)
; 8 = tim off
; 24 = underline off
; 25 = blink off
; 27 = reverse off
; 28 = invisible off
; 30 - 37 = foreground colour
; 40 - 47 = background colour


; generic_console_flags
; bit 2 = blink (probably not implemented)
; bit 3 = underline
; bit 4 = bold
; bit 7 = inverse




; Entry: a = character
; Preserves: hl
__gencon_ansi_attr:
	push	hl
	ld	d,a
	ld	hl,table
loop_table:
	ld	a,(hl)
	cp	255
	jr	z,table_ended
	cp	d
	jr	z,got_attribute
	inc	hl
	inc	hl
	inc	hl
	jr	loop_table
table_ended:
	;Lets consider colours here
	ld	a,d
	cp	30
	jp	m,not_foreground
	cp	37+1
	jp	p,not_foreground
	sub	30
	push	bc
	call	map_colour
	call	generic_console_set_ink
	pop	bc
	pop	hl
	ret

not_foreground:
	cp	40
	jp	m,not_background
	cp	47+1
	jp	p,not_background
	sub	40
	push	bc
	call	map_colour
	call	generic_console_set_paper
	pop	bc
not_background:
	pop	hl
	ret

got_attribute:
	inc	hl
	ld	a,(generic_console_flags)
	and	(hl)
	inc	hl
	or	(hl)
	ld	(generic_console_flags),a
	push	bc
	call	generic_console_set_attribute
	pop	bc
	pop	hl
	ret


map_colour:
	ld	c,a
	ld	b,0
	ld	hl,colourmap
	add	hl,bc
	ld	a,(hl)
	ret


	SECTION	rodata_clib

	;Map between vtrendition and conio.h colours
colourmap:
	defb	0		;BLACK
	defb	4		;RED
	defb	2		;GREEN
	defb	14		;YELLOW
	defb	1		;BLUE
	defb	5		;MAGENTA
	defb	3		;CYAN
	defb	15		;WHITE

	; Table to map VT100 vt attributes into gencon flags	
	; defb vt100_Code
	; defb byte to and with flags
	; defb byte to or with flags
table:
	defb	0	;Reset
	defb	@01100011
	defb	@00000000

	defb	1	;Bold
	defb	@11111111
	defb	@00010000

	defb	2	;Faint
	defb	@11101111
	defb	@00000000

	defb	4	;Underline
	defb	@11111111
	defb	@00001000

	defb	5	;Slow blink
	defb	@11111111
	defb	@00000100

	defb	7	;Inverse
	defb	@11111111
	defb	@10000000

	defb	21	;Bold off
	defb	@11101111
	defb	@00000000

	defb	22	;Bold off/normal intensity
	defb	@11101111
	defb	@00000000

	defb	24	;Underline off
	defb	@11110111
	defb	@00000000

	defb	25	;Blink off
	defb	@11111011
	defb	@00000000

	defb	27	;Inverse off
	defb	@01111111
	defb	@00000000

	defb	255	;End marker

