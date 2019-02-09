
		; code_driver to ensure we don't page ourselves out
		SECTION		code_driver

		PUBLIC		generic_console_vpeek

		EXTERN		__spc1000_mode
		EXTERN		vpeek_MODE1
		EXTERN		vpeek_MODE2
		EXTERN		generic_console_calc_xypos
		EXTERN		__tms9918_console_vpeek



;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	ld	a,(__spc1000_mode)
	cp	1
	jp	z,vpeek_MODE1
	cp	2
	jp	z,vpeek_MODE2
	cp	10
	jp	z,__tms9918_console_vpeek
        call    generic_console_calc_xypos
	ld	c,l
	ld	b,h
	in	a,(c)
	set	3,b
	in	l,(c)
	bit	3,l
	jr	nz,lower_case
	bit	2,l
	jr	nz,high_chars
done:
	and	a
	ret
lower_case:
	cp	$60
	jr	nc,done
	or	128
	jr	done
high_chars:
	and	$0f
	or	$e0
	jr	done


