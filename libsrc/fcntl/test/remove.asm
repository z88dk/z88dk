; Dummy file libs
;

                SECTION code_clib

		PUBLIC	remove
		PUBLIC	_remove

.remove
._remove
	ld	hl,-1	;error
	ret
