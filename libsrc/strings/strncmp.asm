;
; Small C z88 String functions
;
; Compare strings (at most n bytes): s1>s2: >0 s1==s2: 0 s1<s2: <0
;
; Hopefully this is now right! (djm 19/3/2000)
;
; $Id: strncmp.asm,v 1.3 2002-05-10 11:09:22 dom Exp $

                XLIB    strncmp


;strncmp(s1,s2,n) char *s1, *s2
;Stack on entry runs..
;return address,n, s2, s1


.strncmp
IF 0
	ld	ix,0
	add	ix,sp
	ld	c,(ix+2)
	ld	b,(ix+3)
	ld	e,(ix+4)	;s2
	ld	d,(ix+5)
	ld	l,(ix+6)	;s1
	ld	h,(ix+7)
ELSE
       ld      hl,2
        add     hl,sp
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        inc     hl
        ld      e,(hl)  ;s2
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      a,(hl)  ;s1
        inc     hl
        ld      h,(hl)
        ld      l,a
ENDIF
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

