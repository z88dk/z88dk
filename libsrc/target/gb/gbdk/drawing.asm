;; Optimised Drawing library 
;; By Jon Fuge (jonny@q-continuum.demon.co.uk) based on original file
;; Updates
;;   990223 Michael	Removed mod_col, splitting it up into 
;;			__fgcolour, __bgcolour, and __draw_mode
;; Note: some optimisations are available with unneded PUSH DE/POP DE's


    INCLUDE "target/gb/def/gb_globals.def"

	PUBLIC	gmode

	GLOBAL  init_vram
	GLOBAL  copy_vram
	GLOBAL	__mode
	GLOBAL  display_off
	GLOBAL	add_VBL
	GLOBAL	add_LCD
	GLOBAL	y_table

	GLOBAL	__fgcolour
	GLOBAL	__bgcolour
	GLOBAL	__draw_mode
	GLOBAL	lcd


	SECTION	code_driver
	;; Enter graphic mode
gmode:
	DI			; Disable interrupts

	;; Turn the screen off
	LDH	A,(LCDC)
	BIT	7,A
	JR	Z,gmode_1

	;; Turn the screen off
	CALL	display_off
gmode_1:
	LD	HL,0x8000+0x10*0x10
	LD	DE,0x1800-0x18*0x10
	LD	B,0x00
	CALL	init_vram	; Init the charset at 0x8000

	;; Install interrupt routines
	LD	BC,vbl
	CALL	add_VBL
	LD	BC,lcd
	CALL	add_LCD

	LD	A,72		; Set line at which LCD interrupt occurs
	LDH	(LYC),A

	LD	A,@01000100	; Set LCD interrupt to occur when LY = LCY
	LDH	(STAT),A

	LDH	A,(IE)
	OR	@00000010	; Enable LCD interrupt
	LDH	(IE),A

	;; (9*20) = 180 tiles are used in the upper part of the screen
	;; (9*20) = 180 tiles are used in the lower part of the screen
	;; => We have 24 tiles free
	;; We keep 16 at 0x8000->0x80FF, and 8 at 0x9780->97FF

	LD	HL,0x9800
	LD	A,0x10		; Keep 16 tiles free
	LD	BC,12		; 12 unused columns
	LD	E,18		; 18 lines
gmode_2:
	LD	D,20		; 20 used columns
gmode_3:
	LD	(HL+),A
	INC	A
	DEC	D
	JR	NZ,gmode_3
	ADD	HL,BC
	DEC	E
	JR	NZ,gmode_2

	;; Turn the screen on
	LDH	A,(LCDC)
	OR	@10010001	; LCD		= On
				; BG Chr	= 0x8000
				; BG		= On
	AND	@11110111	; BG Bank	= 0x9800
	LDH	(LCDC),A

	LD	A,G_MODE
	LD	(__mode),A

	;; Setup the default colours and draw modes
	LD	A,M_SOLID
	LD	(__draw_mode),A
	LD	A,0x03		; Black
	LD	(__fgcolour),A
	LD	A,0x00		; White
	LD	(__bgcolour),A
	
	EI			; Enable interrupts

	RET

vbl:
	LDH	A,(LCDC)
	OR	@00010000	; Set BG Chr to 0x8000
	LDH	(LCDC),A

	LD	A,72		; Set line at which LCD interrupt occurs
	LDH	(LYC),A

	RET