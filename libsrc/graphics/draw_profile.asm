;
;       Z88DK Graphics Functions
;
;       Draw a "gfx profile" metadata stream - Stefano Bodrato 16/10/2009
;
;		void draw_profile(int dx, int dy, int scale, unsigned char *metapic);
;
;	$Id: draw_profile.asm,v 1.1 2009-10-23 14:25:51 stefano Exp $
;


	INCLUDE	"graphics/grafix.inc"

                XLIB    draw_profile

                LIB     stencil_init
                LIB     stencil_render
                LIB		stencil_add_point
                LIB		stencil_add_lineto
                LIB		stencil_add_side
                LIB		plot
                LIB		unplot
                LIB		draw
                LIB		undraw
                LIB		drawto
                LIB		undrawto
                
                LIB		l_mult
                LIB		l_div

                ;;XREF    COORDS

_percent:	defw	0
_cmd:		defb	0
_dith:		defw	0
_vx:		defw	0
_vy:		defw	0

_cx:		defw	0
_cy:		defw	0
_cx1:		defw	0
_cy1:		defw	0

_pic:		defw	0

_stencil:	defs	maxy*2


getx:
	ld	hl,(_vx)
	call getparm
	ret

gety:
	ld	hl,(_vy)
	call getparm
	ret

getparm:		;cx=vx+percent*pic[x++]/100;
	push hl
	ld	de,(_percent)
	ld	hl,(_pic)
	ld	a,(hl)
	inc	hl
	ld	(_pic),hl
	ld	h,0
	ld	l,a
	call l_mult
	ld	de,100
	ex	de,hl
	call l_div
	pop	de
	ld b,d
	ld c,e
	sub a
	adc	hl,de
	ret nc
	ld d,b
	ld e,c
	ret

draw_profile:
	ld	ix,0
	add ix,sp
	ld	l,(ix+2)
	ld	h,(ix+3)
	ld	(_pic),hl
	ld	h,0
	ld	l,(ix+4)
	ld	(_percent),hl
	ld	l,(ix+6)
	ld	(_vy),hl
	ld	l,(ix+8)
	ld	(_vx),hl
	
picture_loop:
	ld	hl,(_pic)
	ld	a,(hl)
	inc	hl
	ld	(_pic),hl
	and	a		; CMD_END ?
	ret	z
	
	ld	e,a
	and $0F		; 'dithering level'
	ld  h,0
	ld  l,a
	ld	(_dith),hl
	ld	a,e
	and $F0		; command

	ld	hl,_stencil

	cp  $80		; CMD_AREA_INIT (no parameters)
	jr	nz,noinit
	push hl		; _stencil
	call stencil_init
	pop	hl
	jr	picture_loop
noinit:

	cp  $F0		; CMD_AREA_CLOSE (no parameters ?)
	jr	nz,noclose
	push hl		; _stencil
	ld	hl,(_dith)
	ld	a,l
	sub 12
	jr	c,doclose
	; if color > 11 we roughly leave a black border by shrinking
	; the stencil boudaries, then we subtract 7 and fill with the
	; resulting dithering level (12..15 -> 4..7)
	ld	l,11	; black border
	push hl
	call stencil_render
	pop	de
	pop hl
	ld	hl,_stencil	; 'render' can destroy the current parameter
	push hl
	ld	e,1		; left side border
	call resize
	ld	e,-1	; right side border
	call resize
	;pop hl
	;push hl
	;call vshrink	; upper side border
	;ld	hl,_stencil+maxy
	;call vshrink	; lower side border
	ld	hl,(_dith)
	ld	a,l
	sub	7		; adjust dithering to mid values
	ld	l,a
doclose:
	jp	dorender
noclose:
	push af

	cp  $30		; CMD_LINE (4 parameters ?)
	jr	z,fourparms
	cp  $B0		; CMD_AREA_LINE (4 parameters ?)
fourparms:
	push af		; keep zero flag
	call getx
	ld	(_cx),hl
	call gety
	ld	(_cy),hl
	pop	af		; recover zero flag
	jr	nz,twoparms
	call getx
	ld	(_cx1),hl
	call gety
	ld	(_cy1),hl
twoparms:

	pop	af
	
	ld	hl,(_cx)
	push hl
	ld	hl,(_cy)
	push hl
	
	cp	$90	; CMD_AREA_PLOT (x,y)
	jr	nz,noaplot
	ld	hl,_stencil
	push hl
	call stencil_add_point
	jr  go_end3
noaplot:

	cp	$A0	; CMD_AREA_LINETO (x,y)
	jr	nz,noalineto
	ld	hl,_stencil
	push hl
	call stencil_add_lineto
	jr	go_end3
noalineto:

	cp $B0 ; CMD_AREA_LINE (x1,x2,y1,y2)
	jr	nz,noaline
	ld	hl,(_cx1)
	push hl
	ld	hl,(_cy1)
	push hl
	ld	hl,_stencil
	push hl
	call stencil_add_side
	pop hl
go_end4:
	pop	hl
go_end3:
	pop	hl
go_end2:
	pop	hl
go_end1:
	pop	hl
	jp	picture_loop
noaline:

	cp $10 ; CMD_PLOT (x,y,dither),
	jr	nz,noplot
	ld	hl,_stencil
	ld	a,(_dith)
	and	a			; when possible drawto/undrawto are faster
	jr	nz,nopwhite
	call unplot
	jr	go_end2
nopwhite:
	sub 11
	jr	nz,nopblack
	call plot
	jr	go_end2
nopblack:
	push hl
	call stencil_init
	call stencil_add_point
plend:
	pop de	; stencil ptr
plend2:
	pop hl
	pop hl
	push de	; stencil ptr
	ld	hl,(_dith)
	ld	a,l
	sub 12			; If color > 11, then fatten a bit
	jr	c,nothick	; the surface to be drawn

	push hl
	ld hl,_stencil+maxy	; adjust the right side
	ld e,1				; 1 bit larger
	call resize
	pop hl
	ld	a,l
	sub 4	; adjust color (8..11)
	ld	l,a

nothick:
	jr	dorender

noplot:

	cp $20 ; CMD_LINETO (x,y,dither),
	jr	nz,nolineto
	ld	hl,_stencil
	ld	a,(_dith)
	and	a				; when possible drawto/undrawto are faster
	jr	nz,nodtwhite
	call undrawto
	jr	go_end2
nodtwhite:
	sub	11
	jr	nz,nodtblack
	call drawto
	jr	go_end2
nodtblack:
	push hl
	call stencil_init
	call stencil_add_lineto
	jr plend
nolineto:

	cp $30 ; CMD_LINE (x,y,x2,y2,dither),
	jr	nz,go_end2
	ld	hl,(_cx1)
	push hl
	ld	hl,(_cy1)
	push hl
	ld	hl,_stencil
	ld	a,(_dith)
	and	a			; when possible draw/undraw are faster
	jr	nz,nolwhite
	call undraw
	jp	go_end4
nolwhite:
	sub	11
	jr	nz,nolblack
	call draw
	jp	go_end4
nolblack:
	push hl
	call stencil_init
	call stencil_add_side
	pop de
	pop	hl
	pop hl
	jr plend2


dorender:
	push hl
	call stencil_render
	pop	hl
	pop hl
	ld	hl,_stencil	; 'render' can destroy the current parameter
	push hl
	call stencil_init
	pop	hl
	jp	picture_loop


resize:
	ld b,maxy-1
rslp:
	ld a,(hl)
	and a
	jr z,slimit
	cp maxx-1
	jr z,slimit
	add e
	ld (hl),a
slimit:
	inc hl
	djnz rslp
	ret


;vshrink:
;	ld	b,maxy-1
;ltop:
;	ld	a,(hl)
;	and	a
;	jr	z,slim2
;	cp	maxx-1
;	jr	z,slim2
;	dec hl
;	ld	a,(hl)
;	inc	hl
;	ld	(hl),a
;	jr	bottom
;slim2:
;	ld	e,a
;	inc hl
;	djnz ltop
;	ret
;bottom:
;	ld	b,maxy-1
;lbottom:
;	inc	hl
;	ld	a,(hl)
;	and	a
;	jr	z,slim3
;	cp	maxx-1
;	jr	nz,slim4
;slim3:
;	dec	hl
;	ld	(hl),a
;	ret
;slim4:
;	inc	hl
;	djnz lbottom
;	ret

