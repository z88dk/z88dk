;
;	CPC fcntl Library
;
;	Donated by **_warp6_** <kbaccam@free.fr>
;
;	$Id: cpc_closein.asm,v 1.1 2003-09-12 16:30:43 dom Exp $



		XLIB		cpc_closein

		INCLUDE		"#cpcfirm.def"


.cpc_closein
		call		cas_in_close
		ld		hl,1
		ret		c
		ld		hl,-1
		ret

