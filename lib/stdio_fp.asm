
; stdio control block - included into  _crt0.asm
; when ANSIstdio is defined


	defw	0	;stdin
	defb	19
	defb	0
	defw	0	;stdout
	defb	21
	defb	0
	defw	0	;stderr
	defb	21
	defb	0

	defs	7*4	;remaining 7 streams
