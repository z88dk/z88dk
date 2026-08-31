; Smaller, slower VM1 body: 16 * add hl,bc + ret = 170 T, 17 bytes.
; inc hl is 5 T on the 8080-class core, so the 8085 inc-hl slow body
; would not lose to a VM1 extra.
	MODULE	t_vm1_slow

	SECTION	code_compiler

._foo
	add	hl,bc
	add	hl,bc
	add	hl,bc
	add	hl,bc
	add	hl,bc
	add	hl,bc
	add	hl,bc
	add	hl,bc
	add	hl,bc
	add	hl,bc
	add	hl,bc
	add	hl,bc
	add	hl,bc
	add	hl,bc
	add	hl,bc
	add	hl,bc
	ret

	SECTION	code_compiler
	GLOBAL	_foo
