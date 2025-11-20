; Generic console/graphics driver for the VTAC5027 / TMS9927 CRTC
; 

    SECTION code_clib

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_vpeek
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute
    PUBLIC  generic_console_ioctl

    EXTERN  CONSOLE_COLUMNS
    EXTERN  CONSOLE_ROWS

    EXTERN  generic_console_flags

    defc    DISPLAY=0x3000

    defc    CONSOLE_COLUMNS=80
    defc    CONSOLE_ROWS=24

    INCLUDE "ioctl.def"
    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS=CAP_GENCON_INVERSE


generic_console_ioctl:
    scf
generic_console_set_ink:
generic_console_set_paper:
generic_console_set_attribute:
    ret


generic_console_cls:
    ld      hl, DISPLAY
    ld      de,128
    ld      c, ROWS
generic_console_cls_1:
    push    hl
    ld      b, CONSOLE_COLUMNS
generic_console_cls_2:
    ld      (hl), 32
	inc     hl
    djnz    generic_console_cls_2:
    pop     hl
    add     hl,de
    dec     c
    jr      nz,generic_console_cls_1

	ld	hl,screen_copy
	ld	de,screen_copy+1
	ld	bc,+((ROWS+1) * CONSOLE_COLUMNS) - 1
	ld	(hl),0
	ldir

    ret



generic_console_printc:
	push	bc
	call	xypos
	ld	(hl),a
	pop	bc

    ld      hl, DISPLAY
    ld      de, 128
    inc     b
    sbc     hl, de
generic_console_printc_1:
    add     hl, de
    djnz    generic_console_printc_1
    add     hl, bc
    ld      (hl), a

    ret



;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	call	xypos
	ld	a,(hl)
	and	a
	ret



; b = row
; c = column
xypos:
        ld      hl,screen_copy - CONSOLE_COLUMNS
        ld      de,CONSOLE_COLUMNS
        inc     b
generic_console_xypos_1:
        add     hl,de
        djnz    generic_console_xypos_1
        add     hl,bc                   ;hl now points to address in display
		ret



; We avoid LDIR to be 8085 compatible
generic_console_scrollup:

	ld	hl,screen_copy + CONSOLE_COLUMNS
	ld	de,screen_copy
	ld	bc,+((ROWS) * CONSOLE_COLUMNS)   ; 1 more row to wipe the bottom row
	ldir
;	ex	de,hl


    push    de
    push    bc

    ld      hl, DISPLAY
	ld      de, screen_copy
    ld      c,ROWS-1

generic_console_scrollup_1:

    ld      b,CONSOLE_COLUMNS
generic_console_scrollup_2:
    ld      a,(de)
    ld      (hl),a
    inc     hl
    inc     de
    djnz    generic_console_scrollup_2
	
    push    de
    ld      de,128-80
    add     hl,de
    pop     de

    dec     c
    jr      nz,generic_console_scrollup_1

    ld      b, CONSOLE_COLUMNS
generic_console_scrollup_3:
    ld      (hl), 32
    inc     hl
    djnz    generic_console_scrollup_3

    pop     bc
    pop     de
    ret



	SECTION	bss_clib

screen_copy:	
	defs	80 * 26		;Hopefully big enough?



    SECTION code_crt_init
    ; Set the size of the console to this hardware
    EXTERN  __console_w
    EXTERN  __console_h

    ld      a, CONSOLE_COLUMNS
    ld      (__console_w), a
    ld      a, ROWS
    ld      (__console_h), a


	; Init CRTC (and reset scroll register)

;    LD HL,(1BF3h)
;    ;LD (3FFEh),A   ; Writing to this register makes the screen scroll up
;
;    LD BC,3FF0h
;    LD E,7   ; the table contains 7 bytes, we will force the last ones
;vtac_init:
;    LD A,(HL)
;    LD (BC),A
;    INC HL
;    INC BC
;    DEC E
;    JP NZ,vtac_init

    ld      c,$0c	;Reset the video driver, reset scroll register
    call    $00b6
	
	; Hide cursor
	ld a,80
	ld (3FFCh),a
