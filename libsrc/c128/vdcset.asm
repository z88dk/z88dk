;
;Based on the SG C Tools 1.7
;(C) 1993 Steve Goldsmith
;
;$Id: vdcset.asm,v 1.3 2016-06-16 21:13:07 dom Exp $
;

;set vdc reg, d = reg, e = val

        SECTION code_clib
	PUBLIC	vdcset
	PUBLIC	_vdcset

vdcset:
_vdcset:
        ld      bc,0d600h
        out     (c),d
loop1:
        in      d,(c)
        bit     7,d
        jr      z,loop1
        inc     bc
        out     (c),e
        ret

