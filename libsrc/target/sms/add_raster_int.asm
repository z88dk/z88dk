	SECTION code_clib	
	PUBLIC	add_raster_int
	PUBLIC	_add_raster_int
	
	EXTERN	raster_procs

;==============================================================
; add_raster_int(void *ptr)	
;==============================================================
; Adds a VBL/HBL interrupt handler
;==============================================================
.add_raster_int
._add_raster_int
	ld	hl, 2
	add	hl, sp
	ld	c, (hl)		; Proc address
	inc	hl
	ld	b, (hl)
	
	ld	hl, raster_procs

.loop
	ld	a,(hl)
	inc	hl
	or	(hl)
	jr	z, found
	inc	hl
	jr	loop
	
.found
	ld	(hl), b
	dec	hl
	ld	(hl), c
	ret
	
