

        SECTION code_fp_math48

	PUBLIC	atof
	EXTERN  _atof_impl

	; sccz80 points to the implementation

        defc    atof = _atof_impl
