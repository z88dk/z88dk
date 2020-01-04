; Dummy file libs
;

                SECTION code_clib
		PUBLIC	rename
		PUBLIC	_rename

.rename
._rename
	ld	hl,-1	;error
	ret
