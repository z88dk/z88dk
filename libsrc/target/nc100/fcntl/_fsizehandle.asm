;
;	size a file on the Amstrad NC100 (max 64k files so can dump high
; 	bits)
;
;	Supporting helpers
;

		SECTION code_clib
		PUBLIC _fsizehandle
		PUBLIC __fsizehandle
; fastcall
.__fsizehandle
._fsizehandle	ex de, hl
		jp 0xB8B7		; fsizehandle
