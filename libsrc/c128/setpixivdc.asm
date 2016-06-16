;
;Based on the SG C Tools 1.7
;(C) 1993 Steve Goldsmith
;
;$Id: setpixivdc.asm,v 1.3 2016-06-16 21:13:07 dom Exp $
;

;set pixel in 640 x 480 bit map mode.  math and local vdc i/o optimized
;for speed.

		SECTION code_clib
		PUBLIC	setpixivdc
		PUBLIC	_setpixivdc
		EXTERN	_vdcDispMem

		EXTERN	vdcset
		EXTERN	vdcget

;fast pixel look up using x mod 8 as index into bit table

;BitTable:
;
;;defb    -128
;defb    128
;defb    64
;defb    32
;defb    16
;defb    8
;defb    4
;defb    2
;defb    1

setpixivdc:
_setpixivdc:

        pop     hl              ;return address
        pop     de              ;y
        pop     bc              ;x
        push    bc
        push    de
        push    hl

        ld      a,l             ;save y low byte for odd/even test

        srl     d               ;y = y/2
        rr      e
                                ;calc (y * 80) + (x / 8) + bit map start
        ld      l,e             ;hl = y
        ld      h,d

        add     hl,hl           ;hl = y * 64;
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,hl

        ex      de,hl           ;de = y * 64; hl = y

        add     hl,hl           ;hl = y * 16
        add     hl,hl
        add     hl,hl
        add     hl,hl

        add     hl,de           ;hl = (y * 64)+(y * 16)

        ld      e,c             ;de = x
        ld      d,b

        srl     d               ;de = x / 8
        rr      e
        srl     d
        rr      e
        srl     d
        rr      e

        add     hl,de           ;hl = (y * 80) + (x / 8)
        ld      de,(_vdcDispMem)
        add     hl,de           ;hl = (y * 80) + (x / 8) + bit map offset

        and     01h             ;test bit 0 to determine odd/even
        jr      nz,isodd        ;if y odd then
        ld      de,05370h       ; de = odd field offset of 21360 bytes
        add     hl,de           ; hl = hl+21360
isodd:
        ld      a,c             ;a = x low byte
        and     07h             ;a = x mod 8
        ;ld      d,0             ;de = x mod 8
        ;ld      e,a

	xor	7
	ld	b,a
	ld	a,1
	jr	z, or_pixel		; pixel is at bit 0...
.plot_position
	rlca
	djnz	plot_position
.or_pixel

        ;push    ix
        ;ld      ix,BitTable     ;get address of bit table
        ;add     ix,de           ;ix = table addr + (x mod 8)
        ;ld      a,(ix+0)        ;a = bit to set from bit table
        ;pop     ix

        ld      d,18            ;set vdc update addr
        ld      e,h
        call    vdcset

        ld      d,19
        ld      e,l
        call    vdcset

        ld      d,31            ;get current byte
        call    vdcget

        or      e               ;a = current byte or bit table bit

        ld      d,18            ;set vdc update addr
        ld      e,h
        call    vdcset

        ld      d,19
        ld      e,l
        call    vdcset

        ld      d,31            ;set pixel
        ld      e,a
        call    vdcset

        ret

