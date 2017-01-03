; 
; 
;	ZX Spectrum ZXMMC specific routines 
;	code by Stefano Bodrato,   Mar 2010
;
;	$Id: sd_size.asm,v 1.3 2017-01-03 00:27:43 aralbrec Exp $ 
;
; Get the size in bytes of an MMC/SD card
; unsigned long sd_size(struct SD_INFO descriptor);

; Offset in bytes for the CSD field in the MMC struct.
; 1 (slot number) + 1 (slot port) + 1 (flags) + 16 (CID) = 19

defc CSD_OFFSET = 19

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


        PUBLIC    sd_size
        PUBLIC    _sd_size
        INCLUDE "z80_crt0.hdr"
		
.sd_size
._sd_size
		; __FASTCALL__
		
		push	hl	; MMC struct
		pop		ix
		
		ld de,1
		ld hl,1
		ret

	bit 6,(ix+CSD_OFFSET)
	jr nz,sd_csd_v2
		
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


sd_csd_v2:
	ld l,(ix+CSD_OFFSET+9)			; for CSD v2.00
	ld h,(ix+CSD_OFFSET+8)
	inc hl
	ld a,10
	ld bc,0
sd_csd2lp:
	add hl,hl
	rl c
	rl b
	dec a
	jr nz,sd_csd2lp
	ex de,hl				; Return Capacity (number of sectors) in BC:DE
	push de
	push bc
	ld de,0
	ld hl,512
	call    l_long_mult
	ret
		
