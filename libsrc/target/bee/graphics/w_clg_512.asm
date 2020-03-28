;
;       MicroBEE pseudo graphics routines
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - 2016
;
;
;       $Id: w_clg_512.asm,v 1.2 2017-01-02 21:51:24 aralbrec Exp $
;

		SECTION code_clib
		PUBLIC  clg
      PUBLIC  _clg
		EXTERN  cleargraphics
		EXTERN  swapgfxbk


.vdutab		; 64x16
	defb	$6B, $40, $51, $37, $12, $09, $10, $12, $48, $0F, $2F, $0F, 0, 0, 0, 0


.clg
._clg

	call swapgfxbk
	
	; Set 64x16 mode
	LD	HL,vdutab
	LD  C,0
	LD	B,16
.vdloop
	LD	A,C
	OUT	($0C),A
	LD	A,(HL)
	OUT	($0D),A
	INC	HL
	INC C
	DJNZ	vdloop
	

	ld	a,128
	out ($1c),a		; Enable Premium Graphics

	; Init character and attribute map
	ld hl,$f000
	ld bc,1024
	ld d,128	; PCG character #0
	ld e,0		; bank #

.clgloop
	ld	a,128+16
	out ($1c),a		; attribute page
	
	ld a,e
	ld (hl),a
	
	ld	a,128
	out ($1c),a		; back to txt page

	ld a,d
	ld (hl),a
	
	inc hl
	inc d
	
	jr nz,nobank
	inc e
	ld d,128
.nobank

	dec bc
	ld a,b
	or c
	jr nz,clgloop
	
	jp cleargraphics

