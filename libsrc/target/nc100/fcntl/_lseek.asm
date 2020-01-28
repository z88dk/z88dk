;
;	lseek a file on the Amstrad NC100 (max 64k files so can dump high
; 	bits)
;
;	Supporting helpers

		SECTION code_clib;
		PUBLIC nc_lseek		; can't call it fseek as the OS does
		PUBLIC _nc_lseek

.nc_lseek
._nc_lseek
		pop hl
		pop de
		pop bc
		push bc
		push de
		push hl
		call 0xB8B4
		jr c, lseek_ok
		ld bc, 0xffff
lseek_ok:
		ld h, b
		ld l, c
		ret
