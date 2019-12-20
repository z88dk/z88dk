;
;
;       Support char table (pseudo graph symbols) for the Sony SMC-70/SMC-777
;
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


        SECTION rodata_clib
        PUBLIC  textpixl

.textpixl
	defb	 0,  2,  1,  3
	defb	 8, 10,  9, 11
	defb 	 4,  6,  5,  7 
	defb	12, 14, 13, 15

	SECTION	code_clib

construct_block_graphics:
        ld      bc, $0010
        ld      a,0
construct_loop_1:
        ld      d,a
        push    af
        call    do_block
        pop     af
        inc     a
        and     15
        jr      nz,construct_loop_1
        ret

do_block:
        call    do_half_block
do_half_block:
        rr      d
        sbc     a
        and     $0f
        ld      e,a
        rr      d
        sbc     a
        and     $f0
        or      e
        ld      e,4
do_half_block_1:
	out	(c),a
	inc	b
	jr	nz,do_half_block_2
	inc	c
do_half_block_2:
        dec     e
        jr      nz,do_half_block_1
        ret

	SECTION	code_crt_init

	call	construct_block_graphics

