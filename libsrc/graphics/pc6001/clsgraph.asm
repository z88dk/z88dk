
        SECTION code_clib
	PUBLIC	cleargraphics
   PUBLIC   _cleargraphics

	EXTERN	base_graphics

;
;	$Id: clsgraph.asm,v 1.4 2017-01-02 22:57:59 aralbrec Exp $
;

; ******************************************************************
;
;	Clear graphics	area, i.e. reset all bits and sets graphics mode
;
;	Design & programming by Gunther Strube,	Copyright (C) InterLogic 1995
;	ported by Stefano Bodrato
;
;	Registers	changed after return:
;		a.bcdehl/ixiy	same
;		.f....../....	different
;
.cleargraphics
._cleargraphics

;	LD HL,0101h
;	CALL 11CDh      ; L2A - convert location to screen address
;	ld	(base_graphics),hl

; 256x192
    ld      a,1
    call    $140c
    ld      a,2
    call    $1390
    ld      a,1
    call    $13ed                       ;screen 3,2,2  //”’l‚ð-1‚·‚éB
    ld      a,1
    call    $1dbb                       ;color ,,1
    call    $1dfb                       ;cls
;    ret

    ld      a,2
    call    $140c
    ld      a,2
    call    $1390
    ld      a,2
    call    $13ed                       ;screen 3,3,3  //”’l‚ð-1‚·‚éB
    ld      a,1
    call    $1dbb                       ;color ,,1
    call    $1dfb                       ;cls

; set active page
	
	;ld		b,0			; b=2(Page2) b=0(Page3)
	ld		a,($fa27)
	and		$f9
	;or		b
	or		2	; page 2
	ld		($fa27),a
	out		($b0),a

	ld	hl,$e200		;$e2=Page2,$c2=Page3
	ld	(base_graphics),hl

	ret

; 64x48

;    ld      a,1
;    call    $140c
;    ld      a,1
;    call    $1390
;    ld      a,1
;    call    $13ed                       ;screen 2,2,2
;    call    $1dfb                       ;cls
;
;	ld		a,0							;b-1
;    call    $140c
;    ld      a,1							;a-1
;    call    $1390
;    ld      a,0							;c-1
;    call    $13ed						;screen 2,1,1
;    call    $1dfb                       ;cls
;	ret

	
;	push hl
;	ld	a,$E0
;	and	h
;	ld	h,a
;	ld	(hl),128	; init graphics mode
;	pop hl
	
;	ld	(hl),0
;	ld	d,h
;	ld	e,1			; de	= base_graphics+1
;	ld	bc,128*64/4-1
;	ldir				; reset graphics window (2K)
;	ret
