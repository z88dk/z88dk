;
;	ltell a file on the Amstrad NC100 (max 64k files so can dump high
; 	bits)
;
;	Supporting helpers
;

		SECTION code_clib
		PUBLIC nc_ltell
		PUBLIC _nc_ltell

._nc_ltell
.nc_ltell	ex de, hl
		jp 0xB8BD
