;
;Based on the SG C Tools 1.7
;(C) 1993 Steve Goldsmith
;
;$Id: vdcget.asm,v 1.1 2008-06-23 17:34:35 stefano Exp $
;

;get vdc reg, d = reg, e = val

	XLIB	vdcget

vdcget:

        ld      bc,0d600h
        out     (c),d
loop2:
        in      d,(c)
        bit     7,d
        jr      z,loop2
        inc     bc
        in      e,(c)
        ret
