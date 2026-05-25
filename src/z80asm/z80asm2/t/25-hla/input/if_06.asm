%if z
	ld a, 1
%elseif true
	ld a, 2
%elif c
	not reached
%else
	not reached
%endif
