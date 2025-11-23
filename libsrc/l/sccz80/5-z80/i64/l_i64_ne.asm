
    SECTION   code_l_sccz80
    PUBLIC    l_i64_ne
    EXTERN    l_i64_cmp


;       Entry: secondary=acc
;              onstack (under two return addresses) = primary


l_i64_ne:
	call	l_i64_cmp
	scf
	ret	nz
	dec	hl
	ccf
	ret

