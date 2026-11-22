

	SECTION	code_fp_math48

	PUBLIC	ftoe
	EXTERN  _ftoe_impl

; sccz80 points to the implementation

        defc    ftoe = _ftoe_impl
