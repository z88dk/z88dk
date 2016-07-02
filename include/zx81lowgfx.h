/*
 *	LO REZ graphics functions for the ZX 81
 *	(a gfx library needs to be linked in, i.e. "-lgfx81")
 *	
 *	32x48 pixels.
 *
 *	$Id: zx81lowgfx.h,v 1.6 2016-07-02 10:19:07 dom Exp $
 */

#ifndef __ZXLOGFX_H__
#define __ZXLOGFX_H__

#include <sys/compiler.h>

/* Clear and init pseudo-graph screen */
void cclg(int color);

/* Plot a pixel to screen */
void cplot(int x, int y, int color);

/* Get the pixel color */
int cpoint(int x, int y);

/* Draw a line */
void cdraw(int x1, int y1, int x2, int y2, int color);

/* Relative draw */
void cdrawr(int x, int y, int color);

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
cclgstart:
	pop	af
	pop	bc
	push	bc
	push	af

	ld	a,c
cmod3:	sub	3
	jr	nc,cmod3
	add	3
	
	jr	nz,cnoblack
	ld	a,128     ; 0 = black
	jr	cdocls

cnoblack:
	dec	a
	dec	a
	jr	z,cdocls  ; 2= white
	
	ld	a,8       ; 1= gray

cdocls:

#if bufferedgfx
	ld	hl,15200
#else
	ld	hl,(16396)
	inc	hl
#endif

	ld	b,24
crloop:
	push	bc
	ld	(hl),a
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,31
	ldir
	inc	hl
	inc	hl
	ld	(hl),76		; EOL marker (CR equals to the HALT instruction in the ZX81)
	pop	bc
	djnz crloop

	#endasm	
}

/* Plot a pixel to screen */
void cplot(int x, int y, int color)
{
	#asm
	
	pop	af
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl	; Y
	push	bc
	push	af
	ld	h,e	; X
	
	ld	a,c
mod3:	sub	3
	jr	nc,mod3
	add	3
	ld	d,0
	ld	e,a	; color

cplotpixel:

	ld	a,h
	cp	32
	ret	nc
	ld	c,a

	ld	a,l
	cp	48
	ret	nc
	
	push	de	; color

	call	caddr
	
	pop	de	;color

	jr	nc,cevenrow
	
	and	@0011
	rl	e
	rl	e
	or	e
	jr	cencode
	
cevenrow:
	and	@1100
	or	e

cencode:
	ld	e,a
	push	hl
	ld	hl,ctab
	add	hl,de
	ld	a,(hl)
	pop	hl
	ld	(hl),a
	ret

ctab:
defb  128, 138, 131, 255; lower half is black
defb  137,   8,   9, 255; lower half is gray
defb    3,  10,   0     ; lower half is white
     ; |    |    |
     ; |    |    -----> upper half is white
     ; |    --------> upper half is gray
     ; -----------> upper half is black



caddr:
	srl	a	; every "row" has two pixels
	push	af	; save the even/odd bit in carry

	ld	b,a	; row count

#if bufferedgfx
	ld	hl,15200
#else
	ld	hl,(16396)
	inc	hl
#endif

	ld	de,33	; 32+1. Every text line ends with an HALT
	and	a
	jr	z,r_zero
r_loop:
	add	hl,de
	djnz	r_loop
r_zero:
	ld	e,c
	add	hl,de	; hl = char address

	
	ld	a,(hl)	; decode color
	push	hl
	ld	hl,ctab+10
	ld	b,10
cseek:
	cp	(hl)
	jr	z,cfound
	dec	hl
	dec	b
	jr	nz,cseek
cfound:
	pop	hl	; hl = char address

	pop	af	; CY holds the even/odd bit
	ld	a,b	; decoded color
	ret
	
	#endasm
}


/* Get the pixel color */
int cpoint(int x, int y)
{
	#asm
	
	pop	af
	pop	hl
	pop	de
	push	de
	push	hl	; Y
	push	af
	ld	h,e	; X
	
	ld	a,h
	cp	32
	ret	nc
	ld	c,a

	ld	a,l
	cp	48
	ret	nc

	call	caddr

	jr	c,cpevenrow
	
	and	@0011
	jr	cdecoded
	
cpevenrow:
	srl	a
	srl	a

cdecoded:
	
	ld	h,0
	ld	l,a
	ret

	#endasm
}


/* Relative draw */
void cdrawr(int x, int y, int color)
{
	#asm
	EXTERN	Line_r
	
	ld	ix,0
	add	ix,sp
	ld	e,(ix+4)	;py
	ld	d,(ix+5)
	ld	l,(ix+6)	;px
	ld	h,(ix+7)
	ld	a,(ix+2)

mod3dr:	sub	3
	jr	nc,mod3dr
	add	3
	ld	(color+1),a

	ld      ix,csplot
	jp    Line_r
	#endasm
}


/* Draw a line */
void cdraw(int x0, int y0, int x1, int y1, int color)
{
	#asm
	EXTERN	Line
	EXTERN	__gfx_coords
	
	ld	ix,0
	add	ix,sp
	xor	a
	ld	l,(ix+8)	;y0
	ld	h,(ix+10)	;x0
	ld	e,(ix+4)	;y1
	ld	d,(ix+6)	;x1
	ld	a,(ix+2)

mod3drw:	sub	3
	jr	nc,mod3drw
	add	3
	ld	(color+1),a

	push	hl
	push    de
	call	csplot
	pop     de
	pop	hl
	ld      ix,csplot
	call    Line
	ret
	
csplot:
	ld	(__gfx_coords),hl
	push	bc
	ld	d,0
color:	ld	e,0
	call	cplotpixel
	pop	bc
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
        
psmod3:	sub	3
	jr	nc,psmod3
	add	3
        ld	(colr+1),a

	ld	h,d
	ld	l,e

door:
	ld	a,(ix+0)	; Width
	ld	b,(ix+1)	; Height
oloopo:	push	bc		;Save # of rows
	push	af

	;ld	b,a		;Load width (not anymore)
	ld	b,0		; Better, start from zero !!

	ld	c,(ix+2)	;Load one line of image

iloopo:	sla	c		;Test leftmost pixel
	jr	nc,noploto	;See if a plot is needed

	pop	af
	push	af

	push	hl
	
	push	bc	; this should be done by the called routine
	
	push	de
	ld	a,h
	add	a,b
	ld	h,a
	ld	d,0
colr:	ld	e,0
	call	cplotpixel
	pop	de
	
	pop	bc
	
	pop	hl
noploto:

	inc	b	; witdh counter
	
	pop	af
	push	af
	
	cp	b		; end of row ?
	
	jr	nz,noblk
	
	inc	ix
	ld	c,(ix+2)	;Load next byte of image
	
	jr noblocko
	
noblk:
	
	ld	a,b	; next byte in row ?
	;dec	a
	and	a
	jr	z,iloopo
	and	7
	
	jr	nz,iloopo
	
blocko:
	inc	ix
	ld	c,(ix+2)	;Load next byte of image
	jr	iloopo

noblocko:

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
	EXTERN frames
	
	; Sync to avoid screen flickering
;	xor	a
;	ld	(frames),a
;wsync:
;	ld	a,(frames)
;	and	a
;	jr	z,wsync

	; copy the buffer
	ld	hl,15200
	ld	de,(16396)
	inc	de
	;;ld	bc,33*24

	ld	b,24
ccloop:
	push	bc
	ld	bc,32
	ldir
	;;ld	(hl),76		; EOL marker (CR equals to the HALT instruction in the ZX81)
	inc	hl
	inc	de
	pop	bc
	djnz ccloop
#endif

#endasm
}


/* Clear and init pseudo-graph buffer */
void cclgbuffer(int color)
{
#asm

#if bufferedgfx
	jp	cclgstart
#endif
	
#endasm	
}

#endif


