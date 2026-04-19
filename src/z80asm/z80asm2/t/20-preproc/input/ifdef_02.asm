define X 1
Y EQU 2
Z = 3

ifdef X
	ld a, 1
else
	not reached
endif

ifdef Y
	ld a, 2
else 
	not reached
endif

ifdef not_defined_1
	not reached
elseifdef not_defined_2
	not reached
else
	ld a, 3
endif

ifdef not_defined_1
	not reached
elifdef not_defined_2
	not reached
else
	ld a, 4
endif

ifdef X
	ifdef Y
		ifdef Z
			ld a, 5
		else
			not reached
		endif
	else
		not reached
	endif
else
	not reached
endif
