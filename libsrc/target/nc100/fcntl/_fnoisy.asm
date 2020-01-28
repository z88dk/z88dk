			
		SECTION code_clib
		PUBLIC _fnoisy
      PUBLIC __fnoisy
; fastcall
_fnoisy:
__fnoisy:
      ex de, hl
		jp 0xb917
