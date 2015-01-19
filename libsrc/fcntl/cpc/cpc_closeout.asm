;
;	CPC fcntl Library
;
;	Donated by **_warp6_** <kbaccam@free.fr>
;
;	$Id: cpc_closeout.asm,v 1.4 2015-01-19 01:32:43 pauloscustodio Exp $



		PUBLIC		cpc_closeout

		INCLUDE		"cpcfirm.def"


.cpc_closeout
        call    firmware
        defw    cas_out_close
		ld		hl,1
		ret		c
		ld		hl,-1
		ret

