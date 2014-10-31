;
;	ltell a file on the Amstrad NC100 (max 64k files so can dump high
; 	bits)
;
;	Supporting helpers
;
		XLIB nc_ltell

.nc_ltell	ex de, hl
		jp 0xB8BD
