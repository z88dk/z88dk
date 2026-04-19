define expr 1

if expr
	ld a, 1
else
	not reached
endif

if !expr
	not reached
else 
	ld a, 2
endif

if not_defined
	not reached
elseif !not_defined
	ld a, 3
else
	not reached
endif

if not_defined
	not reached
elif !not_defined
	ld a, 4
else
	not reached
endif

if 1
	if 1
		if 1
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
