;--------------------------------------------------------------
; ZX81 HRG library for the Memotech expansion
; by Stefano Bodrato, Feb. 2010
;--------------------------------------------------------------
;
;   Set HRG mode
;
;	$Id: mt_hrg_on.asm,v 1.4 2014-10-21 12:18:26 stefano Exp $
;

	XLIB	mt_hrg_on
	XDEF	hrgmode

	XREF	MTCH_P1
	XREF	MTCH_P2
	XREF	MTCH_P3

	XDEF	hrg_on
	XREF	base_graphics

hrgmode:	defb	2

.mt_hrg_on
.hrg_on

; if hrgpage has not been specified, then set a default value
	ld      hl,(base_graphics)
	ld      a,h
	or      l
	jr		nz,gotpage
IF FORzx81mt64
	ld		hl,29000		; on a 16K system we leave a space of abt 1.5K bytes for stack
ELSE
	ld		hl,25000		; on a 16K system we leave a space of a bit more than 1K for stack
ENDIF
	ld		(base_graphics),hl
gotpage:

	ld		hl,(base_graphics)

	ld	($407b),hl

IF FORzx81mt64
		ld	a,65	; new row counter
ELSE
		ld	a,193	; new row counter
ENDIF
	push af

.floop
	ld (hl),$76
	inc hl
	ld b,32
.zloop
	ld (hl),0
	inc hl
	djnz zloop
	dec a
	jr nz,floop
;	ld (hl),$76

;IF FORzx81mt64
;	ld	($407b),hl
;	ld	de,32
;	ld	b,65	; new row counter
;	call	$246C		; PAGE (only for 64 rows)
;ELSE
;	call	$2464		; PAGE
;ENDIF

	
; Prepare shadow ROM (remapped 1K RAM) for HRG
	ld	hl,0
	ld	de,0
	ld	bc,$400
	ldir

; Patch the shadow rom
	ld	a,$7b			; the new ptr to D-FILE will be $407b
	ld	($0075),a
	;ld	($027a),a		; probably useless, we have our custom handler
	ld	(MTCH_P1+1),a	; patch our custom interrupt handler

	; Force row-in-a-text-line-counter from 8 to 1
	ld	a,$c1		; set 3,c (CB D9) -> set 0,c (CB C1)
					;	incidentally $C1 = 193.. could bring to confusion
	ld	($0040),a

	pop af
	ld	($0285),a
	ld	(MTCH_P2+2),a	; patch also our custom interrupt handler
	
IF FORzx81mt64
	ld	a,85
	ld	(MTCH_P3+1),a	; patch also our custom interrupt handler
ENDIF


	; wait for video sync to reduce flicker
HRG_Sync:
        ld      hl,$4034        ; FRAMES counter
        ld      a,(hl)          ; get old FRAMES
HRG_Sync1:
        cp      (hl)            ; compare to new FRAMES
        jr      z,HRG_Sync1     ; exit after a change is detected

	ld	a,$1f	; ROM address $1F00
	ld	i,a

	ld	a,(hrgmode)
	in	a,($5f)

	ret
