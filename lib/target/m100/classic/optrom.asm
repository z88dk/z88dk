;
;	Startup for m100 optrom mostly based on Stephen Adolph optrom demo:
;	http://bitchin100.com/wiki/index.php?title=OPTROM_Switching&oldid=2419
;	Alexei Gordeev, Nov 2020
;

    ; guaranteed safe place to put some variables
    defc ALTLCD_RAM = $FCC0
    defc ALTLCD_LEN = 320        

    defc OPON = $FAA4
    defc CRT_ORG_DATA = ALTLCD_RAM
    defc CRT_ORG_CODE = $0000

IFNDEF CRT_ORG_BSS
    defc CRT_ORG_BSS = ALTLCD_RAM ; Ram variables will be kept in safe RAM area by default
ENDIF
    defc    __crt_org_bss = CRT_ORG_BSS

    org	  CRT_ORG_CODE
rst0:
	jp	program		; RST0 standard entry

	defs	$08-ASMPC
rst1:
	ret			; RST1 not used
	defs	$10-ASMPC
rst2:
	ret			; RST2 not used

	defs	$18-ASMPC
rst3:
	ret			; RST3 not used

	defs	$20-ASMPC
rst4:
	ret			; RST4 not used

	defs	$24-ASMPC
trap:
	di			; TRAP
	call	intcall

	defs	$28-ASMPC
rst5:
	ret			; RST5 not used

	defs	$2c-ASMPC
rst55:
	di
	call	intcall

	defs	$30-ASMPC
rst6:
	jp	stdcall		;RST 6 used as short call to a Standard ROM routine.

	defs	$34-ASMPC
rst65:
	di	;Replaces the 6.5 interrupt and sets up a call to 6.5 in Standard ROM
	call	intcall

	defs	$38-ASMPC
rst7:
	ret			; RST7 not used

	defs	$3c-ASMPC
rst75:	
	di	;Replaces the 7.5 interrupt and sets up a call to 7.5 in Standard ROM
	call	intcall

	defs	$40-ASMPC
	
OPON_img:
	push	af
	ld	a, $01
	out	$e8
	pop	af
	ret
	
	defs	$48-ASMPC
stdcall:
	ex	(sp), hl
	inc	hl
	inc	hl
	ex	(sp), hl

	push	hl
	ld	hl, OPON
	ex	(sp), hl
	
	push	hl
	push	de

	ldsi	$06	

	lhlx
	dec	hl
	dec	hl
	ex	de, hl
	lhlx
	
	pop	de
	ex	(sp), hl
	jp	stdon

intcall:
	push	hl
	push	de
	
	ldsi	$04
	lhlx

	dec	hl
	dec	hl
	dec	hl
	dec	hl

	push	hl	
	ld	hl, OPON

	shlx
	pop	hl
	pop	de
	ex	(sp), hl	
	jp	stdon

	defs	$85-ASMPC
stdon:
	push	af
	push	hl ; 26C8, F1 C9  POP PSW, RET
	ld	hl, $26c8 ; it returns to this location --> pop psw; ret
	ex	(sp), hl
opexit:
	xor	a
	out	$e8
	ret	; RET can be found at 008EH in stdrom
		; in both M100 and T200

	defs	$94-ASMPC
exit:
	pop	hl
	ld	hl, 0
	ex	(sp), hl	; restart
	jp	opexit
	
program:
    INCLUDE "crt/classic/crt_init_sp.asm"
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
    ei
    push    bc	;argv
    push    bc	;argc
    call    _main
    pop     bc
    pop     bc
cleanup:
    push    hl
    call    crt0_exit
    pop     hl
    jp      exit
