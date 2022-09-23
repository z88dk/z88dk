;
;      Low level cassette control: close and stop writing
;
;      Stefano, 2022
;
;      int msxtape_wr_cls();
;

PUBLIC msxtape_wr_cls
PUBLIC _msxtape_wr_cls


EXTERN	msxbios

IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
ENDIF


.msxtape_wr_cls
._msxtape_wr_cls

	push	ix
	ld	ix,TAPOOF
	call	msxbios
	pop	ix

	ld  hl,0
	ret nc
	dec hl		;error, break condition occured
	ret

