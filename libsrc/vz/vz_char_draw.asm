;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Juergen Buchmueller
;
;*****************************************************

; ----- void vz_char_draw(int x, int y, int c, char ch)

SECTION code_clib
PUBLIC vz_char_draw
PUBLIC _vz_char_draw
EXTERN vz_shape
EXTERN char_shape

; This one tied to vz_shape so can't ween off the stack
; without fixing vz_shape -- so left as is

.vz_char_draw
._vz_char_draw
	push	ix		;save callers ix
	ld	ix, 2
	add	ix, sp
	ld	l,(ix+8)	; get x
	ld	h,(ix+9)
	push	hl
	ld	l, (ix+6)	; get y
	ld	h, (ix+7)
        push    hl
	ld	hl, 5
	push	hl		; width
	push	hl		; height
	ld	l, (ix+4)	; get c
	ld	h, (ix+5)
        push    hl
	ld	a, (ix+2)	; get ch
	cp	$20
	jr	nc, char_shape1
	ld	a, $20
char_shape1:
	cp	$80
	jr	c, char_shape2
	ld	a, $20
char_shape2:
	sub	$20
	ld	l, a		; * 5
	ld	h, 0
	ld	e, l
	ld	d, h
	add	hl, hl
        add     hl, hl
	add	hl, de
	ld	de, char_shape
	add	hl, de
	push	hl		; *data
	push ix
	call	vz_shape
	pop hl
        ld      sp, hl          ; clean up stack
	pop	ix		;restore callers ix
	ret
