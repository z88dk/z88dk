; 
; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Stefano Bodrato,   Mar 2010
;
;	$Id: mmc_size.asm,v 1.3 2016-06-10 21:28:03 dom Exp $ 
;
; Get the size in bytes of an MMC card
; unsigned long mmc_size(struct MMC mmc_descriptor);

; Offset in bytes for the CSD field in the MMC struct.
; 1 (slot number) + 1 (slot port) + 16 (CID) = 18

defc CSD_OFFSET = 18

;
;	Original code:	
;
;	int	c_size;
;	int c_size_mult;
;	int block_len;
;
;	c_size = ((mmc->CSD[6]&3)<<10) + (mmc->CSD[7]<<2) + (mmc->CSD[8]>>6);
;	c_size_mult = 1<<(((mmc->CSD[9]&3)<<1) + (mmc->CSD[10]>>7));
;	block_len = 1 << ((mmc->CSD[5]&15)-8);
;
;	if (c_size == 0xFFF)  return (unsigned long)0;
;	
;	return ( (unsigned long)++c_size * (unsigned long)c_size_mult * (unsigned long)block_len );
;	

	SECTION	  code_clib
        PUBLIC    mmc_size
        PUBLIC    _mmc_size
        INCLUDE "z80_crt0.hdr"
		
.mmc_size
._mmc_size
		; __FASTCALL__
		
		push	hl	; MMC struct
		pop		ix
		
		; c_size
        ld      a,(ix+CSD_OFFSET+6)
        and     #(3 % 256)
        ld      e,a
        ld      d,0
        ld      l,#(10 % 256)
        call    l_asl
        push    hl
        ;ld      hl,2    ;const
        ;add     hl,sp
        ;call    l_gint  ;
		ld      e,(IX+CSD_OFFSET+7)
        ld      d,0
        ld      l,#(2 % 256)
        call    l_asl
        pop     de
        add     hl,de
        push    hl
		ld      a,(IX+CSD_OFFSET+8)
		ld		hl,0
		rla
		rl		l
		rla
		rl		l
        pop     de
        add     hl,de
		inc		hl
		ld		a,h
		cp		$10		; = $fff + 1 ?   then > 2GB
		jr		nz,lessthan2GB
		ld		hl,0
		ret

.lessthan2GB
        ld      de,0		; More significant word of the long variable
        push    de
        push    hl			; _c_size

 
		; c_size_mult
        ld      a,(ix+CSD_OFFSET+9)
        and     #(3 % 256)
        ld      e,a
        ld      d,0
        ;ld      l,#(1 % 256)
        ;call    l_asl
		;push    hl
		sla		e
		rl		d
        push    de
		ld		hl,0
		ld      a,(ix+CSD_OFFSET+10)
		rla
		rl		l			; leftmost bit moved in position 1 (equals to >>7)
        pop     de
        add     hl,de
        ld      de,1
        call    l_asl
        ld      de,0		; More significant word of the long variable
        push    de
        push    hl			; _c_size_mult


		
		; block_len		..should be always 512, but you never know !
        ld      a,(ix+CSD_OFFSET+5)
        and     #(15 % 256)
        ;ld      l,a
        ;ld      h,0
        ;ld      bc,-8		; value to get size in KiloBytes
		;ld      bc,2		; get size in bytes
        ;add     hl,bc
        ;ld      de,1
        ;call    l_asl
		
		;inc  a
		;inc  a
		ld   hl,4
.twopow
		sla   l
		rl	 h
		dec  a
		jr   nz,twopow
        ld      de,0		; More significant word of the long variable

		

		; Now multiply the three values and exit
		call    l_long_mult
		call    l_long_mult
		ret
