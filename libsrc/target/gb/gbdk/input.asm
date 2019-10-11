	MODULE	input

        INCLUDE "target/gb/def/gb_globals.def"	

	;; Note that while gets uses a pointer, the pointer had better
	;; be in non-banked RAM else bad things will happen.
	;; BANKED:	checked, imperfect

	PUBLIC	tmode_inout
	
	GLOBAL	copy_vram
	GLOBAL	set_xy_wtt
	GLOBAL	mv_sprite
	GLOBAL	set_sprite_prop
	GLOBAL	set_sprite_tile
	GLOBAL	asm_jpad
	GLOBAL	waitpadup

	EXTERN	__mode
	EXTERN	display_off
	EXTERN	wait_vbl_done

	defc MINMSPOSX	= 0x02	; In tiles
	defc MINMSPOSY	= 0x0A
	defc MAXMSPOSX	= 0x11
	defc MAXMSPOSY	= 0x0F
	defc INIMSPOSX	= MINMSPOSX
	defc INIMSPOSY	= MINMSPOSY

	defc KBDWINPOSY	= 0x08	; In tiles
	defc KBDSIZE	= 0x1006

	defc MSOFFSETX	= 0x0C	; In pixels
	defc MSOFFSETY	= 0x14

	defc MINACCEL	= 0x0800
	defc MAXACCEL	= 0x0100

	defc CR	= 0x0A		; Unix

	GLOBAL	tmode_out	; From 'output.s'
	GLOBAL	asm_putchar
	GLOBAL	asm_del_char
	GLOBAL	__console_y



	SECTION	bss_driver

msx:				; Mouse position
	defs	0x01
msy:
	defs	0x01
msacc:				; Mouse acceleration
	defs	0x02
msstate:			; Mouse state
	defs	0x01
mschanged:			; Did the mouse move?
	defs	0x01
string_len:			; Used length of input buffer
	defs	0x01


	SECTION	code_driver

	;; Enter text mode with input
tmode_inout:
	DI			; Disable interrupts

	;; Turn the screen off
	LDH	A,(LCDC)
	BIT	7,A
	;; Turn the screen off
	CALL	nz,display_off
	LD	A,(__mode)
	AND	T_MODE
	CALL	Z,tmode_out

	LD	BC,tp1	; Move pointer
	LD	HL,0x8000
	LD	DE,endtp1-tp1
	CALL	copy_vram

	LD	A,MINACCEL / 256	; Acceleration
	LD	(msacc),A
	LD	A,MINACCEL % 256
	LD	(msacc+1),A

	;; Initialize window
	LD	BC,frame_tiles
	LD	DE,0x0000	; Place image at (0x00,0x00) tiles
	LD	HL,0x140A	; Image size is 0x14 x 0x0A tiles
	CALL	set_xy_wtt
	LD	BC,kbdtable
	LD	DE,0x0202	; Place image at (0x02,0x02) tiles
	LD	HL,KBDSIZE	; Image size is 0x10 x 0x06 tiles
	CALL	set_xy_wtt
	XOR	A
	LD	A,MINWNDPOSX
	LDH	(WX),A
	LD	A,MAXWNDPOSY	; Hide window
	LDH	(WY),A

	;; Initialize sprite
	LD	C,0x00		; Sprite 0x00
	LD	D,0x00		; Default sprite properties
	CALL	set_sprite_prop
	LD	C,0x00		; Sprite 0x00
	LD	D,0x00		; Tile 0x00
	CALL	set_sprite_tile
	LD	A,@00101100
	LDH	(OBP0),A

	;; Turn the screen on
	LD	A,@11000001	; LCD		= On
				; WindowBank	= 0x9C00
				; Window	= Off
				; BG Chr	= 0x8800
				; BG Bank	= 0x9800
				; OBJ		= 8x8
				; OBJ		= Off
				; BG		= On
	LDH	(LCDC),A

	LD	A,T_MODE_INOUT
	LD	(__mode),A

	EI			; Enable interrupts

	RET

	;; Prompt the user for a char and return it in A
	PUBLIC	asm_getchar
asm_getchar:
	PUSH	BC
	PUSH	DE
	PUSH	HL
	CALL	show_kbd
	CALL	show_mouse
get_1:
	CALL	track_mouse
	CALL	update_mouse
	CALL	asm_jpad
	LD	D,A
	AND	BUT_A		; Is A pressed ?
	JP	Z,get_1

	LD	A,(msy)	; Look for char under the mouse
	SUB	MINMSPOSY
	JR	Z,get_12
	LD	E,A
	XOR	A
get_11:
	ADD	MAXMSPOSX-MINMSPOSX+1
	DEC	E
	JR	NZ,get_11
get_12:
	LD	E,A
	LD	A,(msx)
	SUB	MINMSPOSX
	ADD	E
	LD	HL,kbdtable
	LD	B,0x00
	LD	C,A
	ADD	HL,BC
	LD	B,(HL)

	CALL	hide_mouse
	CALL	hide_kbd
	LD	A,B

	POP	HL
	POP	DE
	POP	BC
	RET

	;; Prompt the user for a string and store it in (HL)
	PUBLIC	asm_getstring
asm_getstring:
	PUSH	BC
	PUSH	DE
	PUSH	HL
	CALL	show_kbd
	CALL	show_bkg
	CALL	show_mouse
	XOR	A
	LD	(string_len),A
getstr_1:
	CALL	track_mouse
	CALL	update_mouse
	CALL	asm_jpad
	LD	D,A
	AND	BUT_A		; Is A pressed ?
	JP	NZ,getstr_10
	LD	A,D
	AND	BUT_B		; Is B pressed ?
	JP	NZ,getstr_20
	LD	A,D
	AND	SELECT	; Is SELECT pressed ?
	JP	NZ,getstr_30
	LD	A,D
	AND	START		; Is START pressed ?
	JR	Z,getstr_1
	CALL	waitpadup		; Wait for button to be depressed

	LD	A,CR
	CALL	asm_putchar
	LD	(HL),0x00
	CALL	hide_mouse
	CALL	hide_bkg
	CALL	hide_kbd
	POP	HL
	POP	DE
	POP	BC
	RET

getstr_10:
	;; Insert a character at cursor position
	LD	A,(string_len) ; Check buffer length
;	CP	BUFLEN-1	; Keep 1 char for EOS
;	JR	Z,13$
	INC	A
	LD	(string_len),A ; Update it
	LD	A,(msy)	; Look for char under the mouse
	SUB	MINMSPOSY
	JR	Z,getstr_12
	LD	E,A
	XOR	A
getstr_11:
	ADD	MAXMSPOSX-MINMSPOSX+1
	DEC	E
	JR	NZ,getstr_11
getstr_12:
	LD	E,A
	LD	A,(msx)
	SUB	MINMSPOSX
	ADD	E
	PUSH	HL
	LD	HL,kbdtable
	LD	B,0x00
	LD	C,A
	ADD	HL,BC
	LD	A,(HL)
	POP	HL
	LD	(HL+),A		; Add it into input buffer
	CALL	asm_putchar	; Print it
	CALL	show_bkg	; Ensure the text is not hidden
getstr_13:
	CALL	waitpadup		; Wait for button to be depressed
	JP	getstr_1

getstr_20:
	;; Delete a character at cursor position
	LD	A,(string_len) ; Is there any char in the buffer ?
	OR	A
	JR	Z,getstr_21
	DEC	A		; Yes
	LD	(string_len),A ; Update buffer length
	DEC	HL
	CALL	asm_del_char
getstr_21:
	CALL	waitpadup		; Wait for button to be depressed
	JP	getstr_1

getstr_30:
	CALL	hide_mouse
	CALL	hide_bkg
	CALL	hide_kbd
	CALL	waitpadup		; Wait for button to be depressed
	CALL	show_kbd
	CALL	show_bkg
	CALL	show_mouse
	JP	getstr_1

show_kbd:
	PUSH	BC
	PUSH	DE
	LDH	A,(LCDC)
	OR	@00100000	; Window = On
	LDH	(LCDC),A
	LD	A,MAXWNDPOSY	; Show window
showkbd_1:
	BIT	0,A		; Wait for VBL every 2 pixels (slow down)
	JR	NZ,showkbd_2
	LD	B,A
	CALL	wait_vbl_done
	LD	A,B
showkbd_2:
	LDH	(WY),A
	CP	KBDWINPOSY*0x08
	JR	Z,showkbd_99
	DEC	A
	JR	showkbd_1
showkbd_99:
	POP	DE
	POP	BC
	RET

hide_kbd:
	PUSH	BC
	PUSH	DE
	LD	A,KBDWINPOSY*0x08+1
hide_1:				;de window
	BIT	0,A		; Wait for VBL every 2 pixels (slow down)
	JR	Z,hide_2
	LD	B,A
	CALL	wait_vbl_done
	LD	A,B
hide_2:
	LDH	(WY),A
	CP	MAXWNDPOSY
	JR	Z,hide_3
	INC	A
	JR	hide_1
hide_3:
	LDH	A,(LCDC)
	AND	@11011111	; Window = Off
	LDH	(LCDC),A
	POP	DE
	POP	BC
	RET

show_bkg:
	PUSH	BC
	PUSH	DE
	LDH	A,(SCY)
	LD	D,A
	LD	A,(__console_y)
	SUB	KBDWINPOSY-1
	JR	C,show_99
	JR	Z,show_99
	SLA	A		; A = A * 8
	SLA	A
	SLA	A
	SUB	D
	JR	C,show_99
	JR	Z,show_99
	LD	C,A
	LDH	A,(SCY)
show_1:
	BIT	0,A		; Wait for VBL every 2 pixels (slow down)
	JR	Z,show_2
	LD	B,A
	CALL	wait_vbl_done
	LD	A,B
show_2:
	INC	A
	LDH	(SCY),A
	DEC	C
	JR	nz,show_1
show_99:
	POP	DE
	POP	BC
	RET

hide_bkg:
	LDH	A,(SCY)
	OR	A
	RET	Z
	PUSH	BC
	PUSH	DE
hidebkg_1:
	BIT	0,A		; Wait for VBL every 2 pixels (slow down)
	JR	Z,hidebkg_2
	LD	B,A
	CALL	wait_vbl_done
	LD	A,B
hidebkg_2:
	DEC	A
	LDH	(SCY),A
	JR	Z,hidebkg_99
	JR	hidebkg_1
hidebkg_99:
	POP	DE
	POP	BC
	RET

show_mouse:
	LD	A,INIMSPOSX
	LD	(msx),A
	LD	A,INIMSPOSY
	LD	(msy),A
	CALL	set_mouse
	LDH	A,(LCDC)
	OR	@00000010	; OBJ = On
	LDH	(LCDC),A
	RET

hide_mouse:
	LDH	A,(LCDC)
	AND	@11111101	; OBJ = Off
	LDH	(LCDC),A
	RET

track_mouse:
	PUSH	BC
	PUSH	DE
	PUSH	HL
	XOR	A
	LD	(mschanged),A	; Default to no change
	CALL	asm_jpad
	LD	D,A

	LD	HL,msstate
	AND	UP+DOWN+LEFT+RIGHT
	JR	NZ,track_1
	LD	(HL),0x00	; Reset state
	JP	track_99
track_1:
	LD	A,(HL)
	LD	(HL),0x01	; Set state
	OR	A		; Was it 0 ?
	LD	HL,msacc	; Acceleration
	JR	NZ,track_2
				; Yes
	LD	(HL),MINACCEL % 256
	INC	HL
	LD	(HL),MINACCEL / 256
	JR	track_4		; Update position
track_2:
	LD	C,(HL)
	INC	HL
	LD	B,(HL)
	DEC	BC
	LD	A,B
	OR	C
	JR	Z,track_3
	LD	(HL),B
	DEC	HL
	LD	(HL),C
	JP	track_99
track_3:	;Set new acceleration to maximum
	LD	(HL),MAXACCEL % 256
	DEC	HL
	LD	(HL),MAXACCEL / 256
track_4:		;update position
	LD	A,0x01
	LD	(mschanged),A
	LD	A,D
	AND	UP		; Is UP pressed ?
	JR	Z,track_6
	LD	A,(msy)
	CP	MINMSPOSY
	JR	Z,track_5
	DEC	A
	LD	(msy),A
	JR	track_6
track_5:
	LD	A,MAXMSPOSY
	LD	(msy),A
track_6:
	LD	A,D
	AND	DOWN		; Is DOWN pressed ?
	JR	Z,track_8
	LD	A,(msy)
	CP	MAXMSPOSY
	JR	Z,track_7
	INC	A
	LD	(msy),A
	JR	track_8
track_7:
	LD	A,MINMSPOSY
	LD	(msy),A
track_8:
	LD	A,D
	AND	LEFT		; Is LEFT pressed ?
	JR	Z,track_10
	LD	A,(msx)
	CP	MINMSPOSX
	JR	Z,track_9
	DEC	A
	LD	(msx),A
	JR	track_10
track_9:
	LD	A,MAXMSPOSX
	LD	(msx),A
track_10:
	LD	A,D
	AND	RIGHT		; Is RIGHT pressed ?
	JR	Z,track_99
	LD	A,(msx)
	CP	MAXMSPOSX
	JR	Z,track_11
	INC	A
	LD	(msx),A
	JR	track_99
track_11:
	LD	A,MINMSPOSX
	LD	(msx),A
track_99:
	POP	HL
	POP	DE
	POP	BC
	RET

update_mouse:
	LD	A,(mschanged)	; Did it change ?
	OR	A
	RET	Z		; No
set_mouse:
	PUSH	BC
	PUSH	DE
	PUSH	HL
	LD	C,0x00		; Sprite 0x00
	LD	A,(msx)
	SLA	A		; A = A * 8
	SLA	A
	SLA	A
	ADD	MSOFFSETX
	LD	D,A
	LD	A,(msy)
	SLA	A		; A = A * 8
	SLA	A
	SLA	A
	ADD	MSOFFSETY
	LD	E,A
	CALL	mv_sprite
	POP	HL
	POP	DE
	POP	BC
	RET



	;; PENDING: this is unfortunate.  Refed from .tmode_inout
	SECTION	rodata_driver

tp1:

pointers:
	; Tile 0x00
	defb	0xFF,0xFF,0xFE,0x82,0xFC,0x84,0xFC,0x84,0xFE,0x82,0xFF,0xB1,0xCF,0xC9,0x87,0x87
endtp1:

frame_tiles:
	defb	0x1C,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x1D
	defb	0x0F,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0F
	defb	0x0F,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0F
	defb	0x0F,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0F
	defb	0x0F,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0F
	defb	0x0F,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0F
	defb	0x0F,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0F
	defb	0x0F,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0F
	defb	0x0F,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0F
	defb	0x1E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x0E,0x1F

kbdtable:
	;; This is unfortunate.  astorgb and rgbasm cant interpert:
	;;	defm	" !\"#$%&'()*+,-./"
	;; so we have to use the hex form here.
	defb	0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27
	defb	0x28,0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F
	defm	"0123456789:"
	;; astorgb recognises the embedded ; as a comment :)
	defb	0x3B		
	defm	"<=>?"
	defm	"@ABCDEFGHIJKLMNO"
	defm	"PQRSTUVWXYZ[\\]^_"
	defm	"`abcdefghijklmno"
	defm	"pqrstuvwxyz\{\|\}~ "
