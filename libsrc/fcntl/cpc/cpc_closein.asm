;
;	CPC fcntl Library
;
;	Donated by **_warp6_** <kbaccam@free.fr>
;
;	$Id: cpc_closein.asm,v 1.6 2017-01-02 21:02:22 aralbrec Exp $


		SECTION   code_clib
		PUBLIC		cpc_closein
      PUBLIC      _cpc_closein

		INCLUDE		"cpcfirm.def"


.cpc_closein
._cpc_closein
        call    firmware
        defw    cas_in_close
		ld		hl,1
		ret		c
		ld		hl,-1
		ret

