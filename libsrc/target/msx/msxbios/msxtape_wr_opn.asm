;
;      Low level cassette control: open for writing
;
;      Stefano, 2022
;
;      int msxtape_wr_opn();
;

PUBLIC msxtape_wr_opn
PUBLIC _msxtape_wr_opn

PUBLIC msxtape_wr_opn_sub


EXTERN	msxbios

IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
ENDIF


.msxtape_wr_opn
._msxtape_wr_opn
	xor a		;(short leading tone)

.msxtape_wr_opn_sub

	push	ix
	ld	ix,TAPOON
	call	msxbios
	pop	ix

	ld  hl,0
	ret nc
	dec hl		;error, break condition occured
	ret

