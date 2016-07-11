; Cerberus Application Header (Ti83+[SE] App)
;
; hjp - 28 june 2001 - First (clumsy) attempt to write a header-file
; hjp - 29 june 2001 - Fixed/added things
; hjp -  3 july 2001 - Straightened up some things for grayscale
; hjp - 13 july 2001 - Reshaped variable initialisation (clears statvars now)

	MODULE Ti83plus_App_crt0

	DEFINE TI83PLUSAPP	;Used by grayscale interrupt and the such

	EXTERN	_main		; No matter what set up we have, main is
				;  always, always external to this file.

	PUBLIC	cleanup		; used by exit()
	PUBLIC	l_dcal		; used by calculated calls = "call (hl)"


	PUBLIC	_vfprintf	; vprintf is internal to this file so we
				;  only ever include one of the set of
				;  routines

	PUBLIC	exitsp		; Exit variables
	PUBLIC	exitcount	;

	PUBLIC	heaplast	;Near malloc heap variables
	PUBLIC	heapblocks

	PUBLIC	__sgoioblk	; For stdin, stdout, stder

	PUBLIC	base_graphics	; Graphics stuff
	PUBLIC	coords		;

	PUBLIC	bit_irqstatus	; current irq status when DI is necessary

	PUBLIC	cpygraph	; TI calc specific stuff
	PUBLIC	tidi		;
	PUBLIC	tiei		;
;------------------------------
; Begin of Application header:
;------------------------------

	INCLUDE "Ti83p.def"	; ROM / RAM adresses on Ti83+[SE]
        defc    crt0 = 1
	INCLUDE "zcc_opt.def"	;Get compiler defines

	org $4000

	DEFB $80,$0F		;Field: Program length
	DEFB $00,$00,$00,$00	;Length=0 (N/A for unsigned apps)

	DEFB $80,$12		;Field: Program type
	DEFB $01,$04		;Type = Freeware, 0104

	DEFB $80,$21		;Field: App ID
	DEFB $01		;Id = 1

	DEFB $80,$31		;Field: App Build
	DEFB $01		;Build = 1


	DEFB $80,$48		;Field: App Name
beginname:
	DEFINE NEED_AppName
	INCLUDE	"zcc_opt.def"
	UNDEFINE NEED_AppName
endname0:
IF !DEFINED_NEED_AppName | ((endname0-beginname)=0)
	DEFS "TI83+APP"		;App Name (Needs to be 8 bytes)
ENDIF
endname:
	DEFINE NameLength = (endname-beginname)
	IF NameLength < 2	; Padd spaces if not 8 bytes... (horrible)
	defm ''
	ENDIF
	IF NameLength < 3
	defm ''
	ENDIF
	IF NameLength < 4
	defm ''
	ENDIF
	IF NameLength < 5
	defm ''
	ENDIF
	IF NameLength < 6
	defm ''
	ENDIF
	IF NameLength < 7
	defm ''
	ENDIF
	IF NameLength < 8
	defm ''
	ENDIF

	DEFB $80,$81		;Field: App Pages
	DEFB $01		;App Pages = 1

	DEFB $80,$90		;No default splash screen

	DEFB $03,$26,$09,$04	;Field: Date stamp = 
	DEFB $04,$6f,$1b,$80	;5/12/1999

	DEFB $02, $0d, $40	;Dummy encrypted TI date stamp signature
	DEFB $a1, $6b, $99, $f6 
	DEFB $59, $bc, $67, $f5
	DEFB $85, $9c, $09, $6c
	DEFB $0f, $b4, $03, $9b
	DEFB $c9, $03, $32, $2c
	DEFB $e0, $03, $20, $e3
	DEFB $2c, $f4, $2d, $73
	DEFB $b4, $27, $c4, $a0
	DEFB $72, $54, $b9, $ea
	DEFB $7c, $3b, $aa, $16
	DEFB $f6, $77, $83, $7a
	DEFB $ee, $1a, $d4, $42
	DEFB $4c, $6b, $8b, $13
	DEFB $1f, $bb, $93, $8b
	DEFB $fc, $19, $1c, $3c
	DEFB $ec, $4d, $e5, $75

	DEFB $80,$7F		;Field: Program Image length
	DEFB 0,0,0,0		;Length=0, N/A
	DEFB 0,0,0,0		;Reserved
	DEFB 0,0,0,0		;Reserved
	DEFB 0,0,0,0		;Reserved
	DEFB 0,0,0,0		;Reserved


;--------------------------------------
; End of header, begin of startup part
;--------------------------------------
start:
IF DEFINED_GimmeSpeed		;
	ld	a,1		; switch to 15MHz (extra fast)
	rst	28		; bcall(SetExSpeed)
	defw	SetExSpeed	;
ENDIF				;
	rst	$28		; B_CALL(DelRes), we use the statvars-area,
	DEFW	DelRes		;  Cerberus needs to know it's invalid now...
				;
	ld	hl,statvars	; Clear statvars
	ld	(hl),0		;
	ld	d,h		;
	ld	e,l		;
	inc	de		;
	ld	bc,530		; 531-1 bytes
	ldir			;
IF !DEFINED_atexit		; Less stack use
	ld	hl,-6		; 3 pointers (more likely value)
	add	hl,sp		;
	ld	sp,hl		;
	ld	(exitsp),sp	;
ELSE				;
	ld	hl,-64		; 32 pointers (ANSI standard)
	add	hl,sp		;
	ld	sp,hl		;
	ld	(exitsp),sp	;
ENDIF				;
	ld	hl,plotSScreen	;
	ld	(base_graphics),hl
IF DEFINED_GRAYlib		;
	ld	(graybit1),hl	;
	ld	hl,appBackUpScreen
	ld	(graybit2),hl	;
ENDIF				;
	ld      hl,$8080	;
	ld      (fp_seed),hl	;

	EXTERN	fputc_cons
	ld	hl,12
	push	hl
	call	fputc_cons
	pop	hl

IF DEFINED_GRAYlib
 IF DEFINED_GimmeSpeed
	INCLUDE "gray83pSE.asm"	; 15MHz grayscale interrupt
 ELSE
	INCLUDE	"gray83p.asm"		;  6MHz grayscale interrupt
 ENDIF
ENDIF

	im	2		;
	call	_main		;
cleanup:			;
	ld	iy,$89F0	; Load IY (flags) with it's normal value
	im	1		;
IF DEFINED_GimmeSpeed		;
	xor	a		; switch to 6MHz (normal speed)
	rst	28		; bcall(SetExSpeed)
	defw	SetExSpeed	;
ENDIF				;
	call	$50		; B_JUMP(_jforcecmdnochar)
	DEFW	_jforcecmdnochar; Exit back to Cerberus (TIOS)

;-----------------------------------------
; End of startup part, routines following
;-----------------------------------------
l_dcal:
	jp	(hl)		; used as "call (hl)"

tiei:	ei
IF DEFINED_GRAYlib
cpygraph:
ENDIF
tidi:	ret

		defc ansipixels = 96
		IF !DEFINED_ansicolumns
			 defc DEFINED_ansicolumns = 1
			 defc ansicolumns = 32
		ENDIF
		
        INCLUDE "crt0_runtime_selection.asm"
	INCLUDE	"crt0_section.asm"

IF !DEFINED_GRAYlib
cpygraph:
	call	$50		; B_JUMP(GrBufCpy)
	defw	GrBufCpy	; Since we don't have any shellsupport...
ENDIF				;  plus this is safe for possible
				;  Ti83+ Silver Edition at 15MHz

defc intuse = # IntProcEnd-IntProcStart

DEFVARS $8A3A		; statVars (531 bytes of free space) See graylib83p.asm
{			;  for more info on free space in this memory area.
__sgoioblk
	ds.b	40	; 40 bytes = 4 bytes * 10 handles
coords
        ds.w    1	;  2 bytes
base_graphics
        ds.w    1	;  2 bytes
gfx_bank
        ds.w    1	;  2 bytes
exitsp
        ds.w    1	;  2 bytes
exitcount
        ds.b    1	;  1 byte
fp_seed		;not used...
        ds.w    3	;  6 bytes
extra
        ds.w    3	;  6 bytes
fa
        ds.w    3	;  6 bytes
fasign
        ds.b    1	;  1 byte
heapblocks
	ds.w	1	;  2 bytes
heaplast
	ds.w	1	;  2 bytes
hl1save
	ds.w	1	;  2 bytes
de1save
	ds.w	1	;  2 bytes
bc1save
	ds.w	1	;  2 bytes
iysave
	ds.w	1	;  2 bytes	; total 80 bytes
;------------------------------------------------------------------------------
;			!!!BIG TROUBLE!!!
; Grayscale interrupt is 125/130 bytes now, that won't fit into
;  the [max] 118 bytes free here...
; (intwrapper is 44 bytes, so that does fit)
;------------------------------------------------------------------------------
jp_intprocstart			; $8A8A / $8xxx
	ds.b	intuse	; xx bytes used by interrupt routine
freestatvarsA:
	ds.b	113-intuse
intcount
	ds.b	1	;  1 byte  used by interrupt routine
graybit1
	ds.w	1	;  2 bytes used by interrupt routine
graybit2
	ds.w	1	;  2 bytes used by interrupt routine
IV_table			; $8B00 / $8C00
	ds.b	256	;256 bytes used by interrupt routine
freestatvarsB:			; $8C01 / $8C4D
	ds.b	77	; 77 bytes free
}
ENDIF
