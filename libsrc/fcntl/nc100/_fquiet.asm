			
		SECTION code_clib
		PUBLIC _fquiet
      PUBLIC __fquiet
; fastcall
_fquiet:
__fquiet:
      ex de, hl
		jp 0xb91a
