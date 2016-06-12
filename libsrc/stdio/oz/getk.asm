;
;	OZ 700 console library
;
;	getk() Read key status
;
;	$Id: getk.asm,v 1.5 2016-06-12 17:32:01 dom Exp $
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
		ld	a,1
		out	(11h),a
		in	a,(10h)
		bit	6,a
		jr	z,nosym
		call	nocaps
		ld	a,l
		and	a
		jr	z,3
		sub	16
		ld	l,a
		ld	de,symtab
.sytablp	ld	a,(de)
		and	a
		ret	z
		cp	l
		jr	nz,ntsym
		inc	de
		ld	a,(de)
		ld	l,a
		ret
.ntsym		inc	de
		inc	de
		jr	sytablp

.nosym		and	32		; test bit 5
		jr	nz,caps
		ld	a,64
		out	(11h),a
		in	a,(10h)
		and	8
		jr	z,nocaps
.caps
		call	nocaps
		ld	a,l
		and	a
		jr	z,3
		cp	'a'
		jr	c,numsym
		sub	20h
		ld	l,a
		ret
.numsym		cp	'.'
		jr	nz,3
		ld	a,':'+16
		cp	','
		jr	nz,3
		ld	a,39+16
		sub	16
		ld	l,a
		ret

.nocaps
		ld	c,1
.tabptr		ld	hl,cnvtab
		ld	d,0

.rowloop	ld	a,c
		out	(11h),a
		in	a,(10h)
		push	hl

		ld	b,8
		ld	e,0
.increm		rra
		jr	nc,ngotbit

		add	hl,de
		ld	a,(hl)
		and	a
		jr	z,ngotbit	; SHIFT or similar.. go over
		pop	hl
		ld	h,0
		ld	l,a
		ret

.ngotbit	inc	e
		djnz	increm

		pop	hl
		ld	e,8
		add	hl,de
		rl	c
		jr	nc,rowloop
		ld	hl,0
		ret


.cnvtab
		defb	 27,'q',  0,'g','a',  0,  0,  0		; 1
		defb	'1','w','y','h','s','z',  3,  0		; 2
		defb	'2','e','u','j','d','x',  4,  0		; 4
		defb	'3','r','i','k','f','c',  5,  0		; 8
		defb	'4','t','o','l',  6,'v',' ',  0		; 16
		defb	'5','8','p', 13,  7,'b','-',  0		; 32
		defb	'6','9', 12,  0,  8,'n', 13,  0		; 64
		defb	'7','0','.',',',  9,'m',  0,  0		; 128

.symtab
		defb	'q'
		defb	'+'
		defb	'w'
		defb	'-'
		defb	'e'
		defb	'*'
		defb	'r'
		defb	'/'
		defb	't'
		defb	'+'

		defb	'i'
		defb	'?'
		defb	'o'
		defb	'"'
		defb	'p'
		defb	';'

		defb	'l'
		defb	'~'
		defb	'n'
		defb	'^'

		defb	0

; support@it.colt.net

; Special codes:
; 1    -  shift
; 2    -  2nd
; 3    -  menu
; 4    -  new
; 5    -  eject symbol
; 6    -  left
; 7    -  down
; 8    -  right
;		defb	 27,'q',  0,'g','a',  1,  2,  0		; 1
;		defb	'1','w','y','h','s','z',  3,  0		; 2
;		defb	'2','e','u','j','d','x',  4,  0		; 4
;		defb	'3','r','i','k','f','c',  5,  0		; 8
;		defb	'4','t','o','l',  6,'v',' ',  0		; 16
;		defb	'5','8','p', 13,  7,'b','-',  0		; 32
;		defb	'6','9', 12,  1,  8,'n', 13,  0		; 64
;		defb	'7','0','.',',',  9,'m',  0,  0		; 128

