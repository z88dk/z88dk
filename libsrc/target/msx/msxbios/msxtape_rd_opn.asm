;
;      Low level cassette control: open for reading
;
;      Stefano, 2022
;
;      int msxtape_rd_opn();
;

PUBLIC msxtape_rd_opn
PUBLIC _msxtape_rd_opn


EXTERN	msxbios

IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
ENDIF


.msxtape_rd_opn
._msxtape_rd_opn

	push	ix
	ld	ix,TAPION
	call	msxbios
	pop	ix

	ld  hl,0
	ret nc
	dec hl		;error, break condition occured
	ret
