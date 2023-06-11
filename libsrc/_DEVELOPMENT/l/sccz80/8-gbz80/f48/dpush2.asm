        
SECTION code_clib
SECTION code_l_sccz80
PUBLIC    dpush2
EXTERN	  fa

;------------------------------------------------------
; Push FA onto stack under ret address and stacked word
;------------------------------------------------------
dpush2: pop     de      ;save return address
        pop     bc      ;save next word
	ld	hl,dpush2_temp
	ld	a,e
	ld	(hl+),a
	ld	(hl),d
	ld	hl,fa+5
	ld	a,(hl-)
	ld	d,a
	ld	a,(hl-)
	ld	e,a
	push	de
	ld	a,(hl-)
	ld	d,a
	ld	a,(hl-)
	ld	e,a
	push	de
	ld	a,(hl-)
	ld	d,a
	ld	a,(hl-)
	ld	e,a
	push	de
        push    bc      ;restore next word
	ld	hl,dpush2_temp
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
        jp      (hl)    ;return

	SECTION	bss_fp
dpush2_temp:
	defw	0
