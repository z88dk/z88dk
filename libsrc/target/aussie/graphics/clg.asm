;
;       Fast CLS for the Aussie Byte
;       Stefano - 2016
;
;
;	$Id: clg.asm,v 1.2 2017-01-02 21:51:24 aralbrec Exp $
;

		SECTION code_clib
		PUBLIC    clg
      PUBLIC    _clg
		PUBLIC    pchar
		PUBLIC    rdchar
		
		EXTERN    row
		EXTERN    update

defc	crtar	=	30h		; address register port
defc	crtdr	=	32h		; data register

defc	crtsr	=	31h		; status register read
defc	crtdrr	=	33h		; dummy read register
defc	crtcr	=	34h		; control register
defc	crtuw	=	35h		; character output latch
defc	crtur	=	36h		; character input latch
defc	dispen	=	37h		; sync intervals.


;	Modes for the 8002 Crt Controller
defc	widegr	=	80h ; Wide Graphics Mode
defc	bitag	=	01h ; Dot addressable Graphics
defc	thingr	=	82h ; Business Graphics (Thin Line)
defc	normal	=	83h ; normal character attribute



; *************************************

; Set address
setaddr:
		;s6545r	18,h
		LD 	a,18
		call outh
		;s6545r	19,l
		LD 	a,19
outl:
		OUT	(crtar),A
		LD 	a,l
		OUT	(crtdr),A
		ret

outh:
		OUT	(crtar),A
		LD 	a,h
		OUT	(crtdr),A
		ret

; *************************************

.clg
._clg
		call	crtint
		call	home
		call	setgraf			; set attributes to bit graphics
		call	home
		call	clearg			; clear all dots to 0

home:	LD	HL,0
settos:	LD	(update),HL
		;s6545r	12,h			; display start
		LD 	a,12
		call outh
		;s6545r	13,l
		LD 	a,13
		call outl
		
		;s6545r	18,h			; update start
		;s6545r	19,l
		call setaddr
		ret

;****************************************************************
;*		CRT Initialization Routine			*
;****************************************************************

crtint:	LD	HL,80*38+1
		;s6545r	14,h			; set cursor off screen
		LD 	a,14
		call outh
		;s6545r	15,l
		LD 	a,15
		call outl

		;s6545	3,0011$1001b		; 3 lines Vsync, 9 Char Hsync
		LD 	a,3
		OUT	(crtar),A
		LD 	a,@00111001
		OUT	(crtdr),A
		;s6545	4,20			; vertical total lines - 1
		LD 	a,4
		OUT	(crtar),A
		LD 	a,20
		OUT	(crtdr),A
		;s6545	5,0			; adjust register
		LD 	a,5
		OUT	(crtar),A
		xor a
		OUT	(crtdr),A
		;s6545	6,19			; displayed character rows/frame
		LD 	a,6
		OUT	(crtar),A
		LD 	a,19
		OUT	(crtdr),A
		;s6545	7,19			; Sync position
		LD 	a,7
		OUT	(crtar),A
		LD 	a,19
		OUT	(crtdr),A
		;s6545	8,0111$1011b
		LD 	a,8
		OUT	(crtar),A
		LD 	a,@01111011
		OUT	(crtdr),A
		;s6545	9,15
		LD 	a,9
		OUT	(crtar),A
		LD 	a,15
		OUT	(crtdr),A
		ret


;textmode:	;s6545	3,0011$1001b		; 3 lines Vsync, 9 Char Hsync
;		LD 	a,8
;		OUT	(crtar),A
;		LD 	a,@00111001
;		OUT	(crtdr),A
;		;s6545	4,27			; vertical total lines - 1
;		LD 	a,4
;		OUT	(crtar),A
;		LD 	a,27
;		OUT	(crtdr),A
;		;s6545	5,0			; adjust register
;		LD 	a,5
;		OUT	(crtar),A
;		xor a
;		OUT	(crtdr),A
;		;s6545	6,24			; displayed character rows/frame
;		LD 	a,6
;		OUT	(crtar),A
;		LD 	a,24
;		OUT	(crtdr),A
;		;s6545	7,25			; Sync position
;		LD 	a,7
;		OUT	(crtar),A
;		LD 	a,25
;		OUT	(crtdr),A
;		;s6545	8,0100$1000b
;		LD 	a,8
;		OUT	(crtar),A
;		LD 	a,@01001000
;		OUT	(crtdr),A
;		;s6545	9,11
;		LD 	a,9
;		OUT	(crtar),A
;		LD 	a,11
;		OUT	(crtdr),A
;		RET


;	Clear Loop Routine.

clrlop:	;s6545r	18,h			; address to start updating
		;s6545r	19,l
		call setaddr
cloop2:	LD 	a,b
		OR	c
		RET	Z				; finished ??
		LD 	e,0			; no, so set for attr write
		LD 	a,0a3h			; force loc to blank
		call	attrwr
		DEC	BC			; count less one
		JP	cloop2			; loop till all cleared

;****************************************************************
;*	SETGRAF sets Attributes to Bit Graphics Mode for all	*
;*	Character Locations.					*
;****************************************************************

setgraf:
		;s6545	18,0			; set update address = 0
		;s6545	19,0
		ld hl,0
		call setaddr
		
		LD	BC,2048
setl0:	LD 	a,b
		OR	c
		RET	Z
		LD 	e,00h
		LD 	a,bitag			; attribute for bit graphics
		call	attrwr
		DEC	BC
		JP	setl0

;****************************************************************
;*	Clear Graphics Display to 0's				*
;****************************************************************

clearg:	LD	BC,16*80*38		; characters / row by rows (640*576)
		LD 	e,0
		LD 	a,15			; start at row 15
		LD	(row),A

clrg0:	PUSH	DE			; save row / value
		PUSH	BC			; save count
		LD 	a,e			; get fill value
		;;;;;;;;;;;;;;;;;
		call	pchar
		;;;;;;;;;;;;;;;;;
		POP	BC
		POP	DE
		LD	A,(row)
		DEC	a
		LD	(row),A			; all rows done ?
		JP	P,clrg1			; skip if not

		LD 	a,15			; else reset row count
		LD	(row),A
		LD	HL,(update)			; get update address
		INC	HL			; advance
		LD	(update),HL			; save again

clrg1:	DEC	BC
		LD 	a,c			; count less one
		OR	b
		JP	NZ,clrg0			; loop till done
		ret

		
;****************************************************************
;*	Write Character in 'A' to Attribute Ram			*
;****************************************************************

attrwr:	PUSH	AF			; Save Atrribute
		LD 	a,e			; get control bits for operation
		OUT	(crtcr),A			; send to control register

uploop:	IN	A,(crtsr)			; Status
		RLCA				; Make sure previous update done
		JP	NC,uploop			; Wait for bit 7

		POP	AF			; get back Attribute
		OUT	(crtuw),A			; Send char to latch
		LD 	a,31			; Address reg 31 force update
		OUT	(crtar),A			; to address register
		IN	A,(crtdrr)			; dummy register read
		ret


;****************************************************************
;*	PCHAR writes character in 'A' to display		*
;****************************************************************

pchar:	EX	AF,AF

lop21:	IN	A,(crtsr)			; test if updated yet
		RLCA				; Bit 7 to carry
		JP	NC,lop21			; loop if not


		di
;	Send Address to Update
		LD	HL,(update)			; address to write to

		;s6545r	18,h
		;s6545r	19,l
		call setaddr

		LD	A,(row)
		AND	0fh
		LD 	d,a
		LD 	a,@00110000		; 'A' gets control bits
		OR	d
		OUT	(crtcr),A			; send to control latch

;	Now perform Update Write

vwait:	IN	A,(dispen)			; test blanking interval reg
		RRA
		JP	C,vwait			; loop till blanking interval

vw2:	IN	A,(dispen)			; wait till interval passed
		RRA
		JP	NC,vwait


		EX	AF,AF
		OUT	(crtuw),A			; send character to latch

;	Force CRT controller to update

		LD 	a,31
		OUT	(crtar),A

		IN	A,(crtdrr)			; Force crt to accept
		ei
		ret

;****************************************************************
;*	RDCHAR reads the character from location HL from 	*
;*	the display screen and returns it in 'A"		*
;****************************************************************

rdchar:	IN	A,(crtsr)			; test if updated yet
		RLCA				; Bit 7 to carry
		JP	NC,rdchar			; loop if not

		LD	A,(row)
		AND	0fh
		LD 	d,a
		LD 	a,@11110000			; 'A' gets control bits
		OR	d
		OUT	(crtcr),A			; send to control latch

;	Send Address to Read

		;LD	HL,(update)			; address to Read from
		;s6545r	18,h			; address to strobe
		;s6545r	19,l
		call setaddr

;	Now perform Read

		LD 	a,31				; Dummy Reg 31
		OUT	(crtar),A			; strobe update

;	Force CRT controller to update

		IN	A,(crtdrr)			; Force crt to accept
rdcc0:
		nop
		nop

rdch0:	IN	A,(crtsr)			; test if updated yet
		RLCA					; Bit 7 to carry
		JP	NC,rdch0			; loop if not

		IN	A,(crtur)			; read character back
		ret


		
	SECTION bss_clib
.row
         defb   0
.update
         defw   0
