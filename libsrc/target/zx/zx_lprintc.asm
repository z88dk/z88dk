;
; 	ZX printer for the ZX spectrum, print character via ROM call
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

;IF FORts2068
;EXTERN call_extrom
;ELSE
;EXTERN call_rom3
;ENDIF
	

.zx_lprintc

	ld	hl,2
	add	hl,sp
	ld	a,(hl)

.doput
IF STANDARDESCAPECHARS
	cp  10		; CR?
	jr  nz,NoLF
ELSE
	cp  13		; CR?
	jr  nz,NoLF
ENDIF
	ld	a,13
.NoLF
	
	ld      iy,23610        ; restore the right iy value, 

	set 1,(iy+1)	; Set "printer in use" flag
		
	;IF FORts2068
		rst 16
	;ELSE
    ;    call    call_rom3
	;	defw    16            ;call ROM3 outc routine
	;ENDIF
		
	res 1,(iy+1)	; Reset "printer in use" flag
		
	ret

