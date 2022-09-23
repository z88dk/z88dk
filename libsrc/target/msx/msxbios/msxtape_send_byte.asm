;
;      Low level cassette control: send byte
;
;      Stefano, 2022
;
;      int msxtape_send_byte(unsigned char msxbyte) __z88dk_fastcall;
;

PUBLIC msxtape_send_byte
PUBLIC _msxtape_send_byte


EXTERN	msxbios

IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
ENDIF


.msxtape_send_byte
._msxtape_send_byte

	ld	a,l
	push	ix
	ld	ix,TAPOUT
	call	msxbios
	pop	ix

	ld  hl,0
	ret nc
	dec hl		;error, break condition occured
	ret
