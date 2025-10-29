;_operator new(unsigned int)
;_operator delete(void*)


	PUBLIC	__Znwj
	PUBLIC	__ZdlPv
	GLOBAL	_malloc
	GLOBAL	_free

	defc	__Znwj = _malloc
	defc	__ZdlPv = _free

