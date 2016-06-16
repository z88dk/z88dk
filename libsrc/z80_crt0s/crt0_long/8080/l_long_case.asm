;       Small C+ Z80 Run time library
;       case statement.. "8080" mode
;	Stefano - 29/4/2002

                SECTION   code_crt0_sccz80
        PUBLIC l_long_case


;Case statement for longs
;Enter with dehl=number to check against..


.l_long_case
	ld	b,h		;we need HL, so move it to BC
	ld	c,l
        pop     hl              ;switch table location
.swloop
	push	hl
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	(retloc+1),hl
	pop	hl
	
	;ld	a,(hl)
	;inc	hl
	or	(hl)	; is addr 0 ?
	inc	hl
	jr	nz,noz
	jp	(hl)	; fall out to default
.noz	
	push	hl
	ld	a,(hl)
	cp	c
        jr      nz,swfalse
	inc	hl
	ld	a,(hl)
	cp	b
        jr      nz,swfalse
	inc	hl
	ld	a,(hl)
	cp	e
        jr      nz,swfalse
	inc	hl
	ld	a,(hl)
	cp	d
.swfalse
	pop	hl
        inc	hl
	inc	hl
	inc	hl
	inc	hl	; +4 bytes
        jr      nz,swloop

;Have had a match here...

.retloc jp	0
