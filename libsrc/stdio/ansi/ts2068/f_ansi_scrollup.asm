; We should scroll the screen up one character here
; Blanking the bottom row..
        SECTION code_clib
	PUBLIC	ansi_SCROLLUP
	EXTERN     zx_rowtab

.ansi_SCROLLUP
	ld      ix,zx_rowtab
	ld	a,8
.outer_loop
	push	af
	push	ix
        ld	a,23
.inner_loop
	ld      e,(ix+16)
	ld      d,(ix+17)
	ex	de,hl
	ld	e,(ix+0)
	ld	d,(ix+1)
	ld	bc,32
	ldir
; second display
	dec	de
	dec	hl
	set	5,d
	set	5,h
	ld	bc,32
	lddr
	ld	bc,16
	add	ix,bc
	dec	a
	jr	nz,inner_loop
	pop	ix
	pop	af
	inc	ix
	inc	ix
	dec	a
	jr	nz,outer_loop
; clear
	ld	ix,zx_rowtab + (192 - 8) * 2
	ld	a,8
.clear_loop
	push	ix
	ld	e,(ix+0)
	ld	d,(ix+1)
	ld	h,d
	ld	l,e
	ld	(hl),0
	inc	de
	ld	bc,31
	ldir
; second display
	dec hl
	dec de
	set	5,d
	set	5,h
	ex	de,hl
	ld	(hl),0
	ld	bc,31
	lddr
	pop	ix
	inc	ix
	inc	ix
	dec	a
	jr	nz,clear_loop
	ret
