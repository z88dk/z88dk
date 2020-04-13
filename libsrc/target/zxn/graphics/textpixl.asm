

	SECTION	code_graphics

	PUBLIC	textpixl

	defc	BASE = $00

;       .. X. .X XX
;       .. .. .. ..
;
;       .. X. .X XX
;       X. X. X. X.
;
;       .. X. .X XX
;       .X .X .X .X
;
;       .. X. .X XX
;       XX XX XX XX


.textpixl
        defb     BASE+0,  BASE+2,  BASE+1,  BASE+3
        defb     BASE+8,  BASE+10, BASE+9,  BASE+11
        defb     BASE+4,  BASE+6,  BASE+5,  BASE+7
        defb     BASE+12, BASE+14, BASE+13, BASE+15


        SECTION code_graphics

	PUBLIC	zxn_create_tilemap_graphics
	PUBLIC	_zxn_create_tilemap_graphics
	EXTERN	asm_zxn_copytiles


zxn_create_tilemap_graphics:
_zxn_create_tilemap_graphics:
	ld	hl,-256
	add	hl,sp
	ld	sp,hl
        xor     a
make_char_loop:
        ld      b,a
        ex      af,af
        call    create_char
        call    create_char
        ex      af,af
        inc     a
        cp      16
        jr      nz,make_char_loop
	ld	hl,0
	add	hl,sp
	ld	bc,$1000	;16 tiles, start char 0
	call	asm_zxn_copytiles
	ld	hl,256
	add	hl,sp
	ld	sp,hl
	ret

create_char:
        rr      b
        sbc     a,a
        and     0x0f
        ld      c,a
        rr      b
        sbc     a,a
        and     0xf0
        or      c
        ld      c,4
loop:
        ld      (hl),a
        inc     hl
        dec     c
        jr      nz,loop
        ret
