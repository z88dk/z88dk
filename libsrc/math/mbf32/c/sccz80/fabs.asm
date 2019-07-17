
        SECTION code_fp_mbf32

        PUBLIC  fabs

fabs:
IF __CPU_8080__
	ld	a,e
	and	@01111111
	ld	e,a
ELSE
	res	7,e
ENDIF
	ret
