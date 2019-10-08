;
;       Galaksija C Library
;
;	getk() Read key status
;
;	Stefano Bodrato - Nov. 2017
;
;
;	$Id: getk.asm $
;


        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

.getk
._getk
;	call    $cf5
 
 ld de,02034h
.kloop
 ld	a,(de)
 rrca
 jr nc,kpressed
 dec e
 jr nz,kloop
 
kpressed:
	ld a,e
	and a
	jr z,gotk
	
	cp 31
	jr nz,nospc
	inc a
	jr gotk
nospc:

	cp 48
	jr nz,noent
IF STANDARDESCAPECHARS
	ld	a,10
ELSE
	ld	a,13
ENDIF
	jr gotk
noent:

	cp 27
	jr nc,noalpha
	add 64
	jr gotk
noalpha:

 ; TBD: fix symbol codes 42..47:  ';', ':', ',', '=', '.', '/'

	add 16	; number

.gotk
 
	ld  l,a
	ld  h,0
	ret

