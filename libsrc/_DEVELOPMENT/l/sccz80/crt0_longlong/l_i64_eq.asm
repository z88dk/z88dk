
    SECTION   code_l_sccz80
    PUBLIC    l_i64_eq
    EXTERN    l_i64_cmp


;       Entry: secondary=acc
;              onstack (under two return addresses) = primary


l_i64_eq:
	call	l_i64_cmp
	scf
	ret	z
	dec	hl
	ccf
	ret

