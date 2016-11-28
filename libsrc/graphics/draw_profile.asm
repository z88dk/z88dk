;
;       Z88DK Graphics Functions
;
;       Draw a "gfx profile" metadata stream - Stefano Bodrato 16/10/2009
;
;		void draw_profile(int dx, int dy, int scale, unsigned char *metapic);
;
;	$Id: draw_profile.asm,v 1.10 2016-11-28 07:33:11 stefano Exp $
;


	INCLUDE	"graphics/grafix.inc"


		SECTION	  code_clib
                PUBLIC    draw_profile
                PUBLIC    _draw_profile

                EXTERN     stencil_init
                EXTERN     stencil_render
                EXTERN		stencil_add_point
                EXTERN		stencil_add_lineto
                EXTERN		stencil_add_side
                EXTERN		plot
                EXTERN		unplot
                EXTERN		draw
                EXTERN		undraw
                EXTERN		drawto
                EXTERN		undrawto
                
                EXTERN		l_mult
                EXTERN		l_div


getbyte:
	ld	hl,(_pic)
	ld	a,(hl)
	inc	hl
	ld	(_pic),hl
	ret

getx:
	ld	hl,(_vx)
IF maxx > 320
	call getparmx
ELSE
	call getparm
ENDIF
;IF maxx > 320
;	add hl,hl	; double size for X in wide mode !
;ENDIF
	ret

IF maxx > 320
getparmx:		;cx=vx+percent*pic[x++]/50;  (double width)
	push hl
	ld	de,(_percent)
	call	getbyte
	ld	h,0
	ld	l,a
	call l_mult
	ld	de,25	; 50/2
	jr  perc_div
ENDIF

	
	
	
gety:
	ld	hl,(_vy)
	call getparm
	ret

getparm:		;cx=vx+percent*pic[x++]/100;
	push hl
	ld	de,(_percent)
	call	getbyte
	ld	h,0
	ld	l,a
	call l_mult
	ld	de,50	; 100/2
perc_div:
	ex	de,hl
	call l_div
	pop	de
	add	hl,de
;	ld	a,$F0	; negative value ?
;	and	h
;	ret z
;	ld	hl,0
	ret


; *************************
;    MAIN FUNCTION ENTRY
; *************************

draw_profile:
_draw_profile:
	push	ix
	ld	ix,2
	add ix,sp
	ld	l,(ix+2)
	ld	h,(ix+3)
	ld	(_pic),hl
	ld	l,(ix+4)
	;ld	h,0
	ld	h,(ix+5)
	srl h
	rr l
	ld	(_percent),hl
	ld	l,(ix+6)
IF (maxx > 256)
	ld	h,(ix+7)
ENDIF
	ld	(_vy),hl
	ld	l,(ix+8)
IF (maxx > 256)
	ld	h,(ix+9)
ENDIF
	ld	(_vx),hl
	
IF (maxx > 256)
	ld      hl,-maxy*4	; create space for stencil on stack
ELSE
	ld      hl,-maxy*2	; create space for stencil on stack
ENDIF
	add     hl,sp		; The stack usage depends on the display height.
	ld      sp,hl
	ld		(_stencil),hl

picture_loop:
	ld		a,(repcnt)
	and		a
	jr		z,norepeat
	dec		a
	ld		(repcnt),a
	ld		a,(repcmd)
	jr		noend
norepeat:
	call	getbyte
	and	a		; CMD_END ?
	jr		nz,noend
	;******
	; EXIT
	;******
IF (maxx > 256)
	ld      hl,maxy*4	; release the stack space for _stencil
ELSE
	ld      hl,maxy*2	; release the stack space for _stencil
ENDIF
	add     hl,sp
	ld      sp,hl
	pop	ix
	ret

noend:
	ld	e,a
	and $0F		; 'dithering level'
	ld  h,0
	ld  l,a
	ld	(_dith),hl
	ld	a,e
	and $F0		; command

	ld	hl,(_stencil)

;#define CMD_AREA_INIT		0x80	/* no parms */
;#define CMD_AREA_INITB		0x81	/* activate border mode */
;#define REPEAT_COMMAND		0x82	/* times, command */

	cp  $80		; CMD_AREA_INIT (no parameters)
	jr	nz,noinit
	push hl		; _stencil
	ld	a,(_dith)
	cp	2
	jr	z,do_repeat
	ld	hl,0
	ld	(_areaptr),hl
	and a			; no parameters ?
	jr	z,just_init	; then, don't keep ptr for border
	dec	a
	jr	z,init_loop		;$81 ?
	; else (82..) REPEAT_COMMAND
do_repeat:
	call getbyte
	ld	(repcnt),a
	call getbyte
	ld	(repcmd),a
	jp	go_end1
init_loop:	
	ld	hl,(_pic)	; >0, so save current pic ptr
	ld	(_areaptr),hl
just_init:
	pop	hl
	push hl		; _stencil
	call stencil_init
	jp	go_end1
noinit:

	cp  $F0		; CMD_AREA_CLOSE (no parameters ?)
	jr	nz,noclose
;----
	call is_areamode
	jr	z,noclsamode
	push hl
	ld	hl,(_areaptr)
	ld	(_pic),hl	; update picture pointer to pass the area
	ld	hl,0		; twice and draw the border
	ld	(_areaptr),hl
	pop hl
noclsamode:
;----
	push hl		; _stencil
	ld	hl,(_dith)
	ld	a,l
	sub 12
	jr	c,doclose
	; if color > 11 we roughly leave a black border by shrinking
	; the stencil boundaries, then we subtract 7 and fill with the
	; resulting dithering level (12..15 -> 4..7)
	ld	l,11	; black border
	push hl
	call stencil_render
	pop	de
	pop hl
	ld	hl,(_stencil)	; 'render' can destroy the current parameter
	push hl
	ld	e,1		; left side border
	call resize
	ld	e,-1	; right side border
	call resize
	;pop hl
	;push hl
	;call vshrink	; upper side border
	;;;ld	hl,_stencil+maxy
	;ld	hl,_stencil
	;ld	de,maxy
	;add	hl,de
	;call vshrink	; lower side border
	ld	hl,(_dith)
	ld	a,l
	sub	7		; adjust dithering to mid values
	ld	l,a
doclose:
	jp	dorender
noclose:
	push af

;----
	call is_areamode
	jr	z,noamode	; if in 'area mode', we are doing twice;
	pop	af			; in the first pass, plot/line CMDs 
	or $80			; are changed to the equivalent area ones
	push af
noamode:
;----

	pop	af
	push af
	
	cp	$30		; CMD_HLINETO (1 parameter)
	jr	z,xparm
	cp	$B0		; CMD_AREA_HLINETO (1 parameter)
	jr	nz,noxparm
xparm:
	call getx
	ld	(_cx),hl
	jr	twoparms
noxparm:

	cp	$40		; CMD_VLINETO (1 parameter)
	jr	z,yparm
	cp	$C0		; CMD_AREA_VLINETO (1 parameter)
	jr	nz,noyparm
yparm:
	call gety
	ld	(_cy),hl
	jr	twoparms
noyparm:

	cp  $50		; CMD_LINE (4 parameters ?)
	jr	z,fourparms
	cp  $D0		; CMD_AREA_LINE (4 parameters ?)
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
	ld	hl,(_stencil)
	push hl
	call stencil_add_point
	jr  go_end3
noaplot:

	cp	$A0	; CMD_AREA_LINETO (x,y)
	jr	c,noaline
	cp	$D0
	jr	z,aline
	jr	nc,noaline ; >= CMD_AREA_VLINETO
	; AREA_LINETO stuff
	ld	hl,(_stencil)
	push hl
	call stencil_add_lineto
	jr	go_end3

aline:
	;cp $D0 ; CMD_AREA_LINE (x1,x2,y1,y2)
	;jr	nz,noaline
	ld	hl,(_cx1)
	ld	(_cx),hl	; update also the first parameter couple...
	push hl
	ld	hl,(_cy1)
	ld	(_cy),hl	; ..so VLINE and HLINE behave correctly
	push hl
	ld	hl,(_stencil)
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
	ld	hl,(_stencil)
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
	ld hl,(_stencil)	; adjust the right side
IF (maxx > 256)
	ld	de,maxy*2
ELSE
	ld	de,maxy
ENDIF
	add	hl,de
	ld e,1				; 1 bit larger
	call resize
	pop hl
	ld	a,l
	sub 4	; adjust color (8..11)
	ld	l,a
nothick:
dorender:
	push hl
	call stencil_render
	pop	hl
	pop hl
	ld	hl,(_stencil)	; 'render' can destroy the current parameter
	push hl
	call stencil_init
	jr go_end1

noplot:

	cp $20		; CMD_LINETO (x,y,dither),
	jr c,go_end2
	cp $50		; CMD_LINE
	jr z,line
	jr nc,go_end2
	; LINETO stuff
	ld hl,(_stencil)
	ld a,(_dith)
	and a				; when possible drawto/undrawto are faster
	jr nz,nodtwhite
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

line:
	;cp $50 ; CMD_LINE (x,y,x2,y2,dither),
	;jr	nz,go_end2
	ld	hl,(_cx1)
	ld	(_cx),hl	; update also the first parameter couple...
	push hl
	ld	hl,(_cy1)
	ld	(_cy),hl	; ..so VLINE and HLINE behave correctly
	push hl
	ld	hl,(_stencil)
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
	jp plend2

;
; Adjust right or left margin
; of a stencil object by 'e' dots
;

resize:

IF (maxx > 256)

	;EXTERN  l_cmp
	; TODO
	ret

ELSE

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

ENDIF

; NZ if we have prepared a ptr for two-pass mode
is_areamode:
	push hl		; _stencil
	ld	hl,_areaptr
	ld	a,(hl)
	inc	hl
	cp	(hl)
	pop	hl
	ret
;
; Cut 1st and last line from a stencil object
;

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

	SECTION	bss_clib

_areaptr:	defw	0

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

repcmd:		defb	0
repcnt:		defb	0

; moved into stack
;;_stencil:	defs	maxy*2
_stencil:	defw	0
