;
;	readbyte, fastcall fd is in HL
;

		SECTION code_clib
		PUBLIC readbyte
		PUBLIC _readbyte

._readbyte
.readbyte	ex de, hl
		call 0xB899
		jr nc, readeof
		ld h, 0
		ld l, a
		ret
readeof:	ld hl, 0xffff
		ret
