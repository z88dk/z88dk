;
;Based on the SG C Tools 1.7
;(C) 1993 Steve Goldsmith
;
;$Id: vdcget.asm,v 1.2 2015-01-19 01:32:42 pauloscustodio Exp $
;

;get vdc reg, d = reg, e = val

	PUBLIC	vdcget

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
