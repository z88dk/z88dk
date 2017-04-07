;
;	New stdio functions for Small C+
;
;	gets(char *s) - get string from console
;
;
;	$Id: gets.asm,v 1.14 2016-07-02 13:52:42 dom Exp $
;

		MODULE gets
		SECTION	code_clib
		PUBLIC  gets
		PUBLIC  _gets
		EXTERN   fgetc_cons
		EXTERN   fputc_cons
		EXTERN asm_toupper
		EXTERN __cons_state

DEFINE EMULATECURSOR

; Enter in with hl holding the address of string to print

.gets
._gets
	; we don't __FASTCALL__, z88 version of gets needs parameters
	pop	bc
	pop hl
	push hl
	push bc
	ld	d,h	; keep the start of buffer
	ld	e,l
IF EMULATECURSOR
	call	cursor
ENDIF

.getloop
	push	de
	push	hl	; preserve buffer location
	call	fgetc_cons
	ld		a,l
	pop		hl
	pop		de
	and		a
	jr		z,getloop
	cp		8
	jr		z,bs
	cp		12
	jr		nz,nobs
.bs
	push	hl
	and		a
	sbc		hl,de
	pop		hl
	jr		z,getloop
	dec		hl
IF EMULATECURSOR
.dobs
	call	wipecursor	; ' ' + BS
	ld		a,8
	call	conout
	call	wipecursor	; ' ' + BS
	call	cursor
ELSE
	ld		a,8
	call	conout
	ld		a,' '
	call	conout
	ld		a,8
	call	conout
ENDIF
	jr		getloop
.nobs
	cp		10
	jr		z,getend
	cp		13
	jr		z,getend
	cp		6
	jr		nz,nocapslock
	ld		a,(__cons_state)
	or		a
	ld		a,1
	jr		z,setcapslock
	xor		a
.setcapslock
	ld		(__cons_state),a
	jr		getloop
.nocapslock
	ld		c,a
	ld		a,(__cons_state)
	or		a
	ld		a,c
	call		nz, asm_toupper
	ld		(hl),a
	inc		hl
	call	conout
IF EMULATECURSOR
	call	cursor
ENDIF
	jr		getloop	

.getend
IF EMULATECURSOR
	call	wipecursor
ENDIF
	xor	a
	ld	(hl),a
IF STANDARDESCAPECHARS
	ld	a,10	; end with CR
ELSE
	ld	a,13	; end with CR
ENDIF
	call conout
	ld h,d	; set ptr to string
	ld l,e
	ret

.conout
	push	hl
	push	de
	ld		c,a
	push	bc
	call	fputc_cons
	pop		bc
	pop		de
	pop		hl
	ret

IF EMULATECURSOR
.wipecursor
	ld		a,' '
	jr		cursor+2
.cursor
	ld		a,'_'
	call	conout
.chr8
	ld		a,8
	call	conout
	ret
ENDIF
