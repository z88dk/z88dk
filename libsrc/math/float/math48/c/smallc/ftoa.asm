

        SECTION code_fp_math48

	PUBLIC	ftoa
	EXTERN  _ftoa_impl

; sccz80 points to the implementation

        defc    ftoa = _ftoa_impl
