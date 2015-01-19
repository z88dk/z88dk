;
;	CPC fcntl Library
;
;	Donated by **_warp6_** <kbaccam@free.fr>
;
;	$Id: cpc_closein.asm,v 1.4 2015-01-19 01:32:43 pauloscustodio Exp $



		PUBLIC		cpc_closein

		INCLUDE		"cpcfirm.def"


.cpc_closein
        call    firmware
        defw    cas_in_close
		ld		hl,1
		ret		c
		ld		hl,-1
		ret

