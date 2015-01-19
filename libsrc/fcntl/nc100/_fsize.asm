;
;	size a file on the Amstrad NC100 (max 64k files so can dump high
; 	bits)
;
;	Supporting helpers
;
		PUBLIC _fsize
; fastcall
._fsize		jp 0xB8B7		; fsize
