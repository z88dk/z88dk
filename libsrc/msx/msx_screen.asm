;
;	MSX specific routines
;	by Stefano Bodrato, 12/12/2007
;
;	void msx_screen(int mode);
;
;	Change the MSX screen mode; mode in HL (FASTCALL)
;
;	$Id: msx_screen.asm,v 1.3 2007-12-13 11:28:42 stefano Exp $
;

	XLIB	msx_screen
	LIB	msxbios
	LIB	msxextrom
	
        INCLUDE "#msxbios.def"

msx_screen:
	ld	a,l		; FASTCALL parameter passing mode
	ld	c,a		; save screen mode
	ld	a,(0FAF8h)	; use EXBRSA to check if running on MSX1
	and	a
	ld	a,c		; restore screen mode
	jr	z,screen_msx1	; yes
	ld	ix,01B5h	; CHGMDP: change screen mode and initialize palette
	jp	msxextrom
;
screen_msx1:
	ld	ix,CHGMOD
	jp	msxbios
