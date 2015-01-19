;
;	size a file on the Amstrad NC100 (max 64k files so can dump high
; 	bits)
;
;	Supporting helpers
;
		PUBLIC _fsizehandle
; fastcall
._fsizehandle	ex de, hl
		jp 0xB8B7		; fsizehandle
