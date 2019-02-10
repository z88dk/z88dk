;
;Based on the SG C Tools 1.7
;(C) 1993 Steve Goldsmith
;
;$Id: vdcget.asm,v 1.3 2016-06-16 21:13:07 dom Exp $
;

;get vdc reg, d = reg, e = val

        SECTION code_clib
	PUBLIC	vdcget
	PUBLIC	_vdcget

vdcget:
_vdcget:

        ld      bc,0d600h
        out     (c),d
loop2:
        in      d,(c)
        bit     7,d
        jr      z,loop2
        inc     bc
        in      e,(c)
        ret
