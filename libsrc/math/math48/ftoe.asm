

	SECTION	ftoe

	PUBLIC	ftoe
	EXTERN  _ftoe_impl

; sccz80 points to the implementation

        defc    ftoe = _ftoe_impl
