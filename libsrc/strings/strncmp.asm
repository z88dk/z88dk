;
; Small C z88 String functions
;
; Compare strings (at most n bytes): s1>s2: >0 s1==s2: 0 s1<s2: <0
;
; Hopefully this is now right! (djm 19/3/2000)

                XLIB    strncmp


;strncmp(s1,s2,n) char *s1, *s2
;Stack on entry runs..
;return address,n, s2, s1


.strncmp
	ld	ix,0
	add	ix,sp
	ld	c,(ix+2)
	ld	b,(ix+3)
	ld	e,(ix+4)	;s2
	ld	d,(ix+5)
	ld	l,(ix+6)	;s1
	ld	h,(ix+7)
.loop
	ld	a,b
	or	c
	jr	z,setzero
	dec	bc
	ld	a,(de)
	cp	(hl)
	jr	nz,outtahere
	inc	de
	inc	hl
	and	a
	jr	nz,loop
.setzero
	ld	hl,0
	ret
.outtahere
	ld	hl,1
	ret	c
	dec	hl
	dec	hl	;-1
        ret

