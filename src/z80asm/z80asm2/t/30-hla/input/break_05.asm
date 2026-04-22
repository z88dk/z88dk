%repeat
	ld a, 1
	%break if a < b
	ld a, 2
%until a==1
