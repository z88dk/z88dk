;
;Based on the SG C Tools 1.7
;(C) 1993 Steve Goldsmith
;
;$Id: vdcset.asm,v 1.2 2015-01-19 01:32:42 pauloscustodio Exp $
;

;set vdc reg, d = reg, e = val

	PUBLIC	vdcset

vdcset:
        ld      bc,0d600h
        out     (c),d
loop1:
        in      d,(c)
        bit     7,d
        jr      z,loop1
        inc     bc
        out     (c),e
        ret

