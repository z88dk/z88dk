;
;      Tape save routine
;
;      Stefano, 2022
;
;      int msxtape_get_byte();
;

PUBLIC msxtape_get_byte
PUBLIC _msxtape_get_byte


EXTERN	msxbios

IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
ENDIF


.msxtape_get_byte
._msxtape_get_byte

	push	ix
	ld	ix,TAPIN
	call	msxbios
	pop	ix
	ld	a,l
	ld  h,0
	ret nc
	ld hl,-1		;error, break condition occured
	ret
