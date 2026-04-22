%repeat
	ld a, 1
	%continue if a > b
	ld a, 2
%until a==1
