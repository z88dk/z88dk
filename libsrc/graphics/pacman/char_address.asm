;
;       Generic pseudo graphics routines for text-only platforms
;
;       PacMan Hardware port by Stefano Bodrato, 2017
;
;
;       char_address - internal sub
;		in:  b,c (x,y)   out:  hl (address)
;
;
;	$Id:$
;


			INCLUDE	"graphics/grafix.inc"

                        SECTION code_clib
			PUBLIC	char_address



.char_address

			ld  a,c
			
			ld hl,0x401D
			cp  34
			jr	z,hrow
			ld l,0x3D
			cp	35
			jr	z,hrow
			
			ld hl,0x43DD
			xor a
			cp c	; row at 0 position
			jr z,hrow
			ld l,0xFD
			dec c
			jr z,hrow
			
			dec c
			ld hl,0x43A0
			ld d,0
			ld e,c
			add hl,de
			
			inc b
			ld de,0x20
.xpos
			sbc hl,de
			djnz xpos
			add hl,de
			jr	address_found
			
.hrow
			xor a
			add b
			jr z,address_found
.xpos2
			dec hl
			djnz xpos2

.address_found
			
			ret

