/*
 *      LO REZ graphics functions for the ZX Spectrum
 *
 *	$Id: zxlowgfx.h,v 1.1 2003-10-29 13:38:55 stefano Exp $
 */

#ifndef __ZXLOGFX_H__
#define __ZXLOGFX_H__


/* Clear and init pseudo-graph screen */
void cclg(int color);

/* Plot a pixel to screen */
void cplot(int x, int y, int color);

/* Get the pixel color */
int cpoint(int x, int y);

/* Put a sprite on screen */
void cputsprite(int x, int y, int color, void *sprite);


/* Clear and init pseudo-graph buffer */
void cclgbuffer(int color);

/* copy the gfx buffer, if used */
void ccopybuffer(void);



/* Clear and init pseudo-graph screen */
void cclg(int color)
{
	#asm
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	and	7
	out	(254),a
	ld	e,a
	rla
	rla
	rla
	or	e

	ld	hl,16384
	ld	d,h
	ld	e,l
	inc	de

#if lr64x48
	ld	(hl),@11110000
	ld	bc,6144
	ldir
#else
	ld	b,3
bandloop:
	push	bc
	ld	(hl),255
	ld	bc,1024
	ldir

	ld	(hl),0
	ld	bc,1024
	ldir
	
	pop	bc
	djnz	bandloop
#endif

	ld	(hl),a		; color
	ld	bc,767
	ldir

#if bufferedgfx
	ld	hl,64600
	ld	d,h
	ld	e,l
	inc	de
	ld	(hl),a		; color
	ld	bc,767
	ldir
#endif
	#endasm	
}

/* Plot a pixel to screen */
void cplot(int x, int y, int color)
{
	#asm
	
	ld	ix,0
	add	ix,sp
	ld	a,(ix+2)
	and	7
	ld	c,a
	ld	l,(ix+4)
	ld	h,(ix+6)

cplotpixel:

#if lr64x48
	ld	a,h
	cp	64
	ret	nc
	
	ld	a,l
	cp	24
	ret	nc
#else
	ld	a,h
	cp	32
	ret	nc
	
	ld	a,l
	cp	48
	ret	nc
#endif

#if lr64x48
	ld	b,a
	ld	a,h
	srl	a
	ld	h,a
#else
	srl	a	; every "row" has two pixels
	ld	b,a	; row count
#endif

	push	af	; save the even/odd bit in carry

	ld	d,0
	ld	e,h	; column

#if bufferedgfx
	ld	hl,64600
#else
	ld	hl,22528
#endif
	add	hl,de

	ld	e,b

	rl	e	;2

	rl	e	;4

	rl	e
	rl	d	;8

	rl	e
	rl	d	;16

	rl	e
	rl	d	;32
	
	add	hl,de

	pop	af

	ld	a,(hl)
	jr	nc,cevenrow

	and	7
	rl	c
	rl	c
	rl	c
	or	c
	ld	(hl),a
	ret

cevenrow:
	and	@111000
	or	c
	ld	(hl),a
	ret

	#endasm
}

/* Get the pixel color */
int cpoint(int x, int y)
{
	#asm
	
	ld	ix,0
	add	ix,sp
	ld	l,(ix+2)
	ld	h,(ix+4)

getpixel:
	ld	a,h
	cp	32
	ret	nc
	
	ld	a,l
	cp	48
	ret	nc
	
	srl	a	; every "row" has two pixels
	ld	b,a	; row count
	
	push	af	; save the even/odd bit in carry

	ld	d,0
	ld	e,h	; column
	
;#if bufferedgfx
;	ld	hl,64600
;#else
	ld	hl,22528
;#endif
	add	hl,de

	ld	e,b

	rl	e	;2

	rl	e	;4

	rl	e
	rl	d	;8

	rl	e
	rl	d	;16

	rl	e
	rl	d	;32
	
	add	hl,de

	pop	af

	ld	a,(hl)
	jr	nc,gcevenrow

	rra
	rra
	rra
gcevenrow:
	and	7
	ld	h,0
	ld	l,a
	ret

	#endasm
}

/* Put a sprite on screen */


void cputsprite(int color, int x, int y, void *sprite)
{
	#asm

        ld      hl,2   
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ;sprite address
	push	de
	pop	ix

        inc     hl
        ld      e,(hl)
 	inc	hl
        inc     hl
        ld      d,(hl)	; x and y coords

	inc	hl

        inc     hl
        ld	a,(hl)	; color
        and	7
        ld	(colr+1),a

	ld	h,d
	ld	l,e


;        inc	hl
;        inc	hl
;        inc	hl

;        ld      e,(hl)
; 	inc	hl
;        inc     hl
;        ld      d,(hl)	; x and y coords


.door
	ld	a,(ix+0)	; Width
	ld	b,(ix+1)	; Height
.oloopo	push	bc		;Save # of rows
	push	af

	;ld	b,a		;Load width (not anymore)
	ld	b,0		; Better, start from zero !!

	ld	c,(ix+2)	;Load one line of image

.iloopo	sla	c		;Test leftmost pixel
	jr	nc,noploto	;See if a plot is needed

	pop	af
	push	af

	push	hl
	
	push	bc	; this should be done by the called routine
	
	push	de
	ld	a,h
	add	a,b
	ld	h,a
.colr	ld	c,0
	call	cplotpixel
	pop	de
	
	pop	bc
	
	pop	hl
.noploto

	inc	b	; witdh counter
	
	pop	af
	push	af
	
	cp	b		; end of row ?
	
	jr	nz,noblk
	
	inc	ix
	ld	c,(ix+2)	;Load next byte of image
	
	jr noblocko
	
.noblk
	
	ld	a,b	; next byte in row ?
	;dec	a
	and	a
	jr	z,iloopo
	and	7
	
	jr	nz,iloopo
	
.blocko
	inc	ix
	ld	c,(ix+2)	;Load next byte of image
	jr	iloopo

.noblocko

	;djnz	iloopo
	inc	l

	pop	af
	pop	bc		;Restore data
	djnz	oloopo
	ret
	
	#endasm
}

/* copy the gfx buffer, if used */
void ccopybuffer(void)
{
#asm

#if bufferedgfx

	; Sync to avoid screen flickering
	xor	a
	ld	($5C78),a
wsync:
	ld	a,($5C78)
	and	a
	jr	z,wsync

	; copy the buffer
	ld	hl,64600
	ld	de,22528
	ld	bc,768
	ldir
#endif

#endasm
}


/* Clear and init pseudo-graph buffer */
void cclgbuffer(int color)
{
#asm

#if bufferedgfx
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	and	7

	out	(254),a

	ld	hl,64600
	ld	d,h
	ld	e,l
	inc	de
	ld	(hl),a		; color
	ld	bc,767
	ldir
#endif
	
#endasm	
}

#endif


