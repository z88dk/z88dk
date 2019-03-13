;
; 	ZX printer for the ZX81, print character
;	ZX80 is not (yet) supported
;
;	(HL)=char to display
;
;----------------------------------------------------------------
;
;	$Id: zx_lprintc.asm $
;
;----------------------------------------------------------------
;

        SECTION code_clib
	PUBLIC	zx_lprintc

	EXTERN     asctozx81
	EXTERN     restore81

	

.zx_lprintc

	ld	hl,2
	add	hl,sp
	ld	(charpos+1),hl
	ld	a,(hl)

	call    restore81
IF STANDARDESCAPECHARS
	cp  10		; CR?
	jr  nz,NoLF
ELSE
	cp  13		; CR?
	jr  nz,NoLF
ENDIF
	ld	a,$76
	set 1,(ix+1)	; Set "printer in use" flag
	rst 16
	res 1,(ix+1)	; Set "printer in use" flag
	ret
.NoLF

	
IF FORzx80
;; LPRINT-CH
ELSE
	;ld	ix,16384
	set 1,(ix+1)	; Set "printer in use" flag
ENDIF
	
.charpos
	ld	 hl,0
	call asctozx81
	;bit	 6,a		; filter out the dangerous codes
	;ret	 nz	

	rst	16
	
IF FORzx80
;; LPRINT-CH
ELSE
	;ld	ix,16384
	call    restore81
	res 1,(ix+1)	; reset "printer in use" flag
ENDIF

	ret


IF FORzx80

SECTION bss_clib
PR_CC:		defb 0

ELSE
;
ENDIF
