;
;	CPC fcntl Routines
;       Donated by **_warp6_** <kbaccam@free.fr>
;
;	$Id: cpc_setup_open.asm,v 1.1 2003-09-12 16:30:43 dom Exp $
;


		XLIB	cpc_setup_open

; We enter with sp + 4 = buffer, sp + 6 = lengthm sp + 8 = filename
.cpc_setup_open
		ld	ix,4
		add	ix,sp
		ld	e,(ix+0)
		ld	d,(ix+1)
		ld	b,(ix+2)
		ld	l,(ix+4)
		ld	h,(ix+5)
		ret


