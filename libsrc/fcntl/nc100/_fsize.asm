;
;	size a file on the Amstrad NC100 (max 64k files so can dump high
; 	bits)
;
;	Supporting helpers

		SECTION code_clib;
		PUBLIC _fsize
		PUBLIC __fsize
; fastcall
.__fsize
._fsize		jp 0xB8B7		; fsize
