;--------------------------------------------------------------
; ZX81 HRG library for the Memotech expansion
; by Stefano Bodrato, Feb. 2010
;--------------------------------------------------------------
;
;   Set HRG mode
;
;	$Id: mt_hrg_on.asm,v 1.2 2010-02-10 16:37:48 stefano Exp $
;

	XLIB	mt_hrg_on
	XDEF	hrgmode

	XREF	MTCH_P1
	XREF	MTCH_P2

	XREF	hrg_on
	XREF	base_graphics

hrgmode:	defb	2

.mt_hrg_on
; Prepare shadow ROM (remapped 1K RAM) for HRG
	ld	hl,0
	ld	de,0
	ld	bc,$400
	ldir

; Patch the shadow rom
	ld	a,$7b
	ld	($0075),a
	ld	($027a),a
	ld	(MTCH_P1+1),a	; patch our custom interrupt handler

	; Force row-in-a-text-line-counter from 8 to 1
	ld	a,$c1		; set 3,c (CB D9) -> set 0,c (CB C1)
					;	incidentally $C1 = 193.. could bring to confusion
	ld	($0040),a

IF FORzx81hr64
		ld	a,65	; new row counter
ELSE
		ld	a,193	; new row counter
ENDIF
	ld	($0285),a
	ld	(MTCH_P2+2),a	; patch also our custom interrupt handler

	ld		hl,(base_graphics)

IF FORzx81hr64
	ld	($407b),hl
	ld	de,32
	ld	b,65	; new row counter
	call	$246C		; PAGE (64 rows only)
ELSE
	call	$2464		; PAGE
ENDIF

	ld	a,$1f	; ROM address $1F00
	ld	i,a

	; wait for video sync to reduce flicker
HRG_Sync:
        ld      hl,$4034        ; FRAMES counter
        ld      a,(hl)          ; get old FRAMES
HRG_Sync1:
        cp      (hl)            ; compare to new FRAMES
        jr      z,HRG_Sync1     ; exit after a change is detected

	ld	a,(hrgmode)
	in	a,($5f)

	ret
