

	SECTION	ftoa

	PUBLIC	ftoa
	EXTERN  _ftoa_impl

; sccz80 points to the implementation

        defc    ftoa = _ftoa_impl
