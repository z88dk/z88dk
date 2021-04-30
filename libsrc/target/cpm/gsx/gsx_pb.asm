
;
; GSX/GIOS parameter block
;


PUBLIC	gios_pb
PUBLIC	_gios_pb

PUBLIC	gios_ctl
PUBLIC	_gios_ctl


PUBLIC	gios_intin
PUBLIC	_gios_intin

PUBLIC	gios_ptsin
PUBLIC	_gios_ptsin

PUBLIC	gios_intout
PUBLIC	_gios_intout

PUBLIC	gios_ptsout
PUBLIC	_gios_ptsout



SECTION data_clib

; Parameter block

gios_pb:
_gios_pb:
	defw gios_ctl		; Addr of control array
	defw gios_intin  	; Addr of integer input array
	defw gios_ptsin  	; Addr of pixel input array
	defw gios_intout 	; Addr of integer input array
	defw gios_ptsout	; Addr of pixel input array




SECTION bss_clib

gios_ctl:
_gios_ctl:
	defw 0  ; GSX function, 1-33
	defw 0  ; number of pts in ptsin
	defw 0  ; number of pts in ptsout
	defw 0  ; number of values in intin
	defw 0  ; number of values in intout 
	defw 0  ; for special uses


; limited to 200 bytes, e.g.  printable text max. 100 characters
gios_intin:
_gios_intin:
	defs 200

; limited to 160 bytes, e.g. max 40 corners in graphics objects
gios_ptsin:
_gios_ptsin:
	defs 160

; should be max 12 words, thus 24 bytes
gios_ptsout:
_gios_ptsout:
	defs 30

; should be max 65 words, thus 130 bytes
gios_intout:
_gios_intout:
	defs 140


