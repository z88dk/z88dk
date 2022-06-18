;
;	ZX81 specific routines
;	by Stefano Bodrato, 16/06/2022
;
;	int __FASTCALL__ zx_goto(int line);
;
;	Executes a sequence of program lines
;	Returns an error code if one of the commands fails.
;	The STOP statement can be used as a sort of "RETURN" command.
;	In that case, to handle errors, consider that its error code is #9.
;
;   GOTO etc are not supported, a minimum of conditional code is possible with an IF..THEN line
;
;	$Id: zx_goto.asm$
;

SECTION code_clib
PUBLIC	zx_goto	
PUBLIC	_zx_goto
EXTERN	restore81

; enter : hl = line number

zx_goto:
_zx_goto:
IF FORlambda
        call    $0B36           ; routine LINE-ADDR (LAMBDA)
ELSE
        call    $09D8           ; routine LINE-ADDR (ZX81)
ENDIF
	jr z,havelines				; exit if not exact line
	ld	hl,-1
	ret


havelines:
    push ix
	; ld ix,$4000		; 'restore81' does it already

	call	restore81

	ld	bc,($4002)
	push	bc		; save original ERR_SP

basic_loop:
        inc	hl
        inc	hl
        inc	hl
        inc	hl
	ld	($4016),hl	; CH_ADD

	ld	bc,return
	push	bc
	ld	($4002),sp	; update error handling routine
IF FORlambda
        jp	$088
ELSE
        jp	$cc1	; single line
ENDIF

return:
IF FORlambda
	ld	a,($4007)
ELSE
	ld	a,($4000)
ENDIF

	cp 8		; STOP statement ?   If so, get back to C 
	jr z,exitgoto

   ; We simulate the BASIC interpreter loop manually
	ld	hl,($4016)   ; CH_ADD
.end_line
	ld  a,(hl)
	cp  $76
	inc hl
	jr  z,basic_loop

	ld  a,(hl)
	cp  $76          ; end of BASIC listing ?
	jr  nz,end_line  ; no, continue and pick the next BASIC line
	; no more lines to execute

exitgoto:
IF FORlambda
	ld	h,0
	ld	a,($4007)
	ld	l,a		; error code (hope so !)
	ld	a,255
	ld	($4007),a	; reset ERR_NR

	inc	l		; return with error code (0=OK, etc..)
ELSE
	ld	h,0
	ld	a,($4000)
	ld	l,a		; error code (hope so !)
	ld	a,255
	ld	($4000),a	; reset ERR_NR

	inc	l		; return with error code (0=OK, etc..)
ENDIF


	pop	bc
	ld	($4002),bc	; restore orginal ERR_SP
	pop ix
	ret
