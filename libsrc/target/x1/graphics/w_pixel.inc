
	EXTERN w_pixeladdress

	EXTERN	getmaxy
	EXTERN	getmaxx
	EXTERN	l_cmp
	EXTERN	__gfx_coords

	EXTERN	__x1_attr

; Generic code to handle the pixel commands
; Define NEEDxxx before including

    push    hl		;save x
    call    getmaxy		;hl = maxy
    inc     hl
    call    l_cmp
    pop     hl
    ret     nc

    ex      de,hl		;de = x, hl = y
    push    hl		;save y
    call    getmaxx
    inc     hl
    call    l_cmp
    pop     hl
    ret     nc
    ex      de,hl
    ld      (__gfx_coords),hl	;x
    ld      (__gfx_coords+2),de	;y
    push    bc
    call    w_pixeladdress
    ld      b,a
    ld      a,1
    jr      z, rotated 	; pixel is at bit 0...
.plot_position	
    rlca
    djnz    plot_position
	; a = byte holding pixel mask
	; hl = address
rotated:
    ld      e,a
IF NEEDplot | NEEDunplot
    ld      c,l	;Get the port into the right place
    ld      b,h
    cpl
    ld      h,a
  IF NEEDplot
    ld      a,(__x1_attr)
  ELSE
    ld      a,(__x1_attr+1)
  ENDIF
    ld      l,a
    ld      d,e	;Byte to output
    rrc     l
    jr      c,write_blue
    ld      d,0
write_blue:
    in      a,(c)
    and     h
    or      d
    out     (c),a
    set     7,b	;Toggle to red page
    res     6,b
    ld      d,e
    rrc     l
    jr      c,write_red
    ld      d,0
write_red:
    in      a,(c)
    and     h
    or      d
    out     (c),a
    set     6,b	;Add toggle to green
    ld      d,e
    rrc     l
    jr      c,write_green
    ld      d,0
write_green:
    in      a,(c)
    and     h
    or      d
    out     (c),a
ENDIF

IF NEEDxor
    ld      c,l	;Get the port into the right place
    ld      b,h
    ld      a,(__x1_attr)
    ld      l,a
    ld      d,e	;Byte to output
    rrc     l
    jr      c,write_blue
    ld      d,0
write_blue:
    in      a,(c)
    xor     d
    out     (c),a
    set     7,b	;Toggle to red page
    res     6,b
    ld      d,e
    rrc     l
    jr	    c,write_red
    ld      d,0
write_red:
    in      a,(c)
    xor     d
    out     (c),a
    set     6,b	;Add toggle to green
    ld      d,e
    rrc     l
    jr      c,write_green
    ld      d,0
write_green:
    in      a,(c)
    xor     d
    out     (c),a
ENDIF
IF NEEDpoint
    ld      c,l	;Get the port into the right place
    ld      b,h
    ld      d,0
    set     7,b	;Green page
    in      a,(c)
    and     e
    jr      z,ck_red
    set     2,d
ck_red:
    res     6,b	;Red page
    in      a,(c)
    and     e
    jr      z,ck_blue
    set     1,d
ck_blue:
    res     7,b
    set     6,b
    in      a,(c)
    and     e
    jr      z,skip_blue
    set     0,d
skip_blue:
	; d is the colour we've got selected
    ld      a,d
    and     a
ENDIF
    pop     bc		;Restore callers
    ret
