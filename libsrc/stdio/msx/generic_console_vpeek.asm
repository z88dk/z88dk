

	MODULE	generic_console_vpeek
	SECTION	code_lib
	PUBLIC	generic_console_vpeek

	EXTERN	__msx_font32
	EXTERN	__msx_udg32
	EXTERN	screendollar
	EXTERN	screendollar_with_count
	EXTERN	msxbios

IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ENDIF
IF FORsvi
        INCLUDE "target/svi/def/svibios.def"
ENDIF
IF FORm5
        INCLUDE "target/m5/def/m5bios.def"
ENDIF
IF FORmtx
	EXTERN	LDIRMV
ENDIF
IF FORpv2000
	EXTERN	LDIRMV
ENDIF


generic_console_vpeek:
	push	ix
        ld      a,c
        add     a
        add     a
        add     a
        ld      e,a	
        ld      d,b
	ld	hl,-8
	add	hl,sp
	ld	sp,hl
	push	hl		;save buffer
	; de = VDP address
	; hl = buffer
	ex	de,hl
	ld	ix,LDIRMV
	ld	bc,8
	call	msxbios
	pop	de		;buffer
	ld	hl,(__msx_font32)
	call	screendollar
	jr	nc,gotit
	ld	hl,(__msx_udg32)
	ld	b,128
	call	screendollar_with_count
	jr	c,gotit
	add	128
gotit:
	ex	af,af
	ld	hl,8
	add	hl,sp
	ld	sp,hl
	ex	af,af
        pop     ix
        ret
