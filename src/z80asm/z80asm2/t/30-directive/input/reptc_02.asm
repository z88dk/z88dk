reptc v, "hello" " " "world"
	defb v
endr
reptc v, hello " " world
	defb v
endr
reptc v, 123 456
	defb v
endr
define version = 123
reptc v, version
	defb v
endr
reptc v, 1.23
	defb v
endr
reptc v1, 123
	reptc v2, 456
		defb v1, v2
	endr
endr
