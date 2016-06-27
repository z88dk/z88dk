;--------------------------------------------------------------
; ZX81 HRG library for the G007 expansion
; by Stefano Bodrato, Fall 2014
;--------------------------------------------------------------
;
;   Set HRG mode
;
;	$Id: g007_hrg_on.asm,v 1.6 2016-06-27 20:26:33 dom Exp $
;

	SECTION   code_clib
	PUBLIC    hrg_on
	PUBLIC    _hrg_on
	EXTERN     base_graphics

	EXTERN	L0292
	EXTERN	G007_P1
	EXTERN	G007_P2
	EXTERN	G007_P3


.hrg_on
._hrg_on

	ld		hl,($2306)		; Current HRG page (use CLS 2 / SLOW 4, in BASIC, first)
	ld		(base_graphics),hl	
	
;; if hrgpage has not been specified, then set a default value
;	ld      hl,(base_graphics)
;	ld      a,h
;	or      l
;	jr		nz,gotpage
;IF FORzx81g64
;	ld		hl,29000		; on a 16K system we leave a space of abt 1.5K bytes for stack
;ELSE
;	ld		hl,25000		; on a 16K system we leave a space of a bit more than 1K for stack
;ENDIF
;	ld		(base_graphics),hl
;gotpage:

;	ld		hl,(base_graphics)
	
;	ld		($2306),hl		; probably not necessary, bur emulators may like it
	ld		de,9
	add		hl,de
;	ld		($2308),hl		; probably not necessary, bur emulators may like it

IF FORzx81g64
		ld	a,65	; new row counter
ELSE
		ld	a,193	; new row counter
ENDIF
	push af

.floop
	ld b,34
.zloop
	ld (hl),0
	inc hl
	djnz zloop
	dec a
	jr nz,floop

;	ld (hl),$76
;	inc hl
;	ld (hl),$76



	; wait for video sync to reduce flicker
;HRG_Sync:
;        ld      hl,$4034        ; FRAMES counter
;        ld      a,(hl)          ; get old FRAMES
;HRG_Sync1:
;        cp      (hl)            ; compare to new FRAMES
;        jr      z,HRG_Sync1     ; exit after a change is detected

; Patch the shadow rom
	pop af
	;ld	a,193
	ld	(G007_P2+2),A	; patch our custom interrupt handler
	
	ld	hl,display_3
	ld	(G007_P1+1),hl
	ld	(G007_P3+1),hl

	
;IF FORzx81g64
;	ld	a,85
;	ld	(MTCH_P3+1),a	; patch also our custom interrupt handler
;ENDIF




	ld	a,$1f	; ROM address $1F00 +  enable graphics mode and shadow memory blocks
	ld	i,a

	ret



.display_3
;  HRG replacement fot DISPLAY-3
	dec	hl
	ld	a,($4028)
	ld	c,a
	pop	iy			;  z80asm will do an IX<>IY swap
        ld   a,($403B)      ; test CDFLAG
        and  128            ; is in FAST mode ?
;	bit	7,(ix+$eb)	;  z80asm will do an IX<>IY swap
	jp	nz,$29d
        ;; zx81 rom:   jp   nz,$2a9         ; if so, jp to DISPLAY-4

	ld	a,$fe
	ld	b,1
	ld	hl,$2d9a
	call $2d95
	add	hl,hl
	nop
	ld	e,a
	ld  hl,(base_graphics)	; Start address of HRG display file, less 9
	set	7,h
	jp	(iy)		;  z80asm will do an IX<>IY swap



; This is a DISPLAY-5 variant, perhaps toggling between "JP (HL)" and "HALT"
;00002D95:	LD R,A
;00002D97:	LD A,DDh
;00002D99:	EI
;00002D9A:	HALT



