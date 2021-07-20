;
; Pixel operation for MODE6
;

	EXTERN	__gfx_coords
	EXTERN	pixeladdress_MODE6
	EXTERN	l_cmp
        EXTERN  __gfx_fatpix

; We enter here with: hl = x, de = y
        push    hl              ;save x
	ld	hl,192		;hl = maxy
        inc     hl
        call    l_cmp
        pop     hl
        ret     nc

        ex      de,hl           ;de = x, hl = y
        push    hl              ;save y
	ld	hl,512		;max x
        inc     hl
        call    l_cmp
        pop     hl
        ret     nc
        ex      de,hl
        ld      (__gfx_coords),hl       ;x
        ld      (__gfx_coords+2),de     ;y

	push	bc		;Save callers
	call	pixeladdress_MODE6
        ld      b,a
        ex      af,af
        ld      a,(__gfx_fatpix)
        and     a
        ld      c,@00000001
        jr      z,not_fatpix_rotate
        ld      c,@00000011
        res     0,b
not_fatpix_rotate:
        ex      af,af
        ld      a,c
        jr      z, continue	; pixel is at bit 0...
.plot_position 
	rlca
        djnz    plot_position
continue:
	; So here we have de=hl=screen location
	; a = pixel mask
IF NEEDplot	
	or	(hl)
	ld	(hl),a
ENDIF
IF NEEDunplot
	cpl
	and	(hl)
	ld	(hl),a
ENDIF
IF NEEDxor
	xor	(hl)
	ld	(hl),a
ENDIF
IF NEEDpoint
	and	(hl)
ENDIF
	pop	bc	;Restore callers
	ret


