;
; Convert characters to/from ASCII/Sharp MZ character set
;
; Character set documented here: https://www.sharpmz.org/mz-700/codetable.htm

		SECTION		code_clib

		PUBLIC		sharpmz_from_ascii
		PUBLIC		sharpmz_to_ascii

; Entry: a = ASCII
;        a = sharp mz character
; Changes: hl, e
sharpmz_from_ascii:
        cp      48      ; Between 0 and 9 ?
        jr      c,isntnum
        cp      58
        jr      nc,isntnum
        sub     16      ; Ok, re-code to the Sharp Display set
	ret
.isntnum
        cp      97      ; Between a and z ?
        jr      c,isntlower
        cp      123
        jr      nc,isntlower
        add     a,32
	ret
.isntlower
        cp      65      ; Between A and Z ?
        jr      c,isntchar
        cp      91
        jr      nc,isntchar
        sub     64
	ret
.isntchar
        ;add    a,63 ; For now...
        ld      hl,chmap
        ld      e,a
.maploop
        ld      a,(hl)
        and     a
        ld      a,e
		jr      nz,cont_remap
		sub		80     ; remap to a graphics symbol if we miss a valid equivalent
        ret
.cont_remap
        cp      (hl)
        inc     hl
        jr      z,chfound
        inc     hl
        jr      maploop
.chfound
        ld      a,(hl)
	ret
		

sharpmz_to_ascii:
	cp	$20
	jr	c, not_digit
	cp	$2a
	jr	nc, not_digit
	add	16
	ret
not_digit:
	cp	$81
	jr	c, not_lcase
	cp	$9b
	jr	nc, not_lcase
	sub	32
	ret
not_lcase:
	cp	$01
	jr	c,not_ucase
	cp	$1b
	jr	nc,not_ucase
	add	64
	ret
not_ucase:
	; It's not upper case, we're going to need to search through the mapping table

        ld      hl,chmap
.toascii_1
        ld      e,a
        ld      a,(hl)
        and     a
        ld      a,e
        ret     z       ; Not mapped, just return the raw code
	inc	hl
        cp      (hl)
        jr      z,toascii_2
        inc     hl
        jr      toascii_1
.toascii_2
	dec	hl
        ld      a,(hl)
        ret



	SECTION	rodata_clib

.chmap
        defb    ' ',0
        defb    $a3,$1b
        defb    '-',$2a
        defb    '=',$2b
        defb    ';',$2c
        defb    '/',$2d
        defb    '.',$2e
        defb    ',',$2f
        defb    '_',$3c
        defb    '?',$49
        defb    ':',$4f
        defb    '}',$40
        defb    '^',$50
        defb    '<',$51
        defb    '[',$52
        defb    ']',$54
        defb    '@',$55
        defb    '>',$57
        defb    '\\',$59
        defb    '!',$61
        defb    '"',$62
        defb    '#',$63
        defb    '$',$64
        defb    '%',$65
        defb    '&',$66
        defb    39,$67
        defb    96,$67
        defb    '(',$68
        defb    ')',$69
        defb    '+',$6a
        defb    '*',$6b
        defb    '|',$79
        defb    0
