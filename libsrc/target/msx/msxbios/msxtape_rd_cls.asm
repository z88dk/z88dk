;
;      Low level cassette control: close and stop reading
;
;      Stefano, 2022
;
;      int msxtape_rd_cls();
;

PUBLIC msxtape_rd_cls
PUBLIC _msxtape_rd_cls


EXTERN	msxbios

IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
ENDIF


.msxtape_rd_cls
._msxtape_rd_cls

	push	ix
	ld	ix,TAPIOF
	call	msxbios
	pop	ix

	ld  hl,0
	ret nc
	dec hl		;error, break condition occured
	ret

