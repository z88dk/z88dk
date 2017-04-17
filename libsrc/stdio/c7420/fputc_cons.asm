;
;	ROM Console routine for the Philips Videopac C7420
;	By Stefano Bodrato - 2015
;	Apr, 2107:   fixes and improvements
;
;	$Id:fputc_cons.asm,  2017, Stefano $
;

	SECTION	code_clib
	PUBLIC	fputc_cons_native

.fputc_cons_native

; ODDLY THIS DOESN'T WORK !   (O2EM emulator problem ?)
;        ld      hl,2
;        add     hl,sp
;        ld      a,(hl)
		
	pop bc
	pop hl
	ld a,l
	push hl
	push bc

IF STANDARDESCAPECHARS
	cp  13
	ret z
	cp	10
ELSE
	cp  10
	ret z
	cp	13
ENDIF
	jr	nz,nocr
	ld	a,131		; ENTER
.nocr

	cp	8
	jr	nz,nobs
	ld	a,130		; RUBOUT
.nobs

	cp	12
	jr	nz,nocls
	;ld	a,159		; VIDINI (slower)
	ld	a,157		; CLEARA
	call outchar
	ld	a,140		; HOME
.nocls


	cp '$'
	jr	nz,nodollar
	ld	a,4
.nodollar

	cp '#'
	jr	nz,nohash
	ld	a,6
.nohash

	cp '^'
	jr	nz,nopow
	ld	a,13
.nopow


.outchar

	
	push af
	pop af
	rst	$30
	
	ret
