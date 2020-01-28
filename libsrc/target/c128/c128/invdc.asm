;
;Based on the SG C Tools 1.7
;(C) 1993 Steve Goldsmith
;
;$Id: invdc.asm,v 1.3 2016-06-16 21:13:07 dom Exp $
;

;get vdc register

	SECTION code_clib
	PUBLIC	invdc
	PUBLIC	_invdc

invdc:
_invdc:
        ;pop     de              ;return address
        ;pop     hl              ;vdc register to set
        ;push    hl
        ;push    de
        
        ; __FASTCALL__, so vdc register to set is in HL already
        
        ld      a,l
        ld      bc,0d600h       ;vdc status port
        out     (c),a           ;set reg to read
test7:
        in      a,(c)           ;repeat
        bit     7,a             ;  test bit 7
        jr      z,test7            ;until bit 7 high
        inc     bc              ;vdc data register
        in      l,(c)           ;get data
        ld      h,0
        ret


;uchar invdc(uchar RegNum)
;{
;  outp(vdcStatusReg,RegNum);                  /* internal vdc register to read */
;  while ((inp(vdcStatusReg) & 0x80) == 0x00); /* wait for status bit to be set */
;  return(inp(vdcDataReg));                    /* read register */
;}
