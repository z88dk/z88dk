;
;	ZX IF1 & Microdrive functions
;	
;	void if1_update_map (int drive, char *mdvmap);
;
;	
;	Load in a Microdrive MAP array (32 bytes) 
;	the actual values for the specified drive.
;	
;	$Id: if1_update_map.asm,v 1.1 2005-11-21 11:49:40 stefano Exp $
;


		XLIB 	if1_update_map

filename:	defm	"!h7$"		; foo file name: it will never be written !

if1_update_map:
		rst	8
		defb 	31h		; Create Interface 1 system vars if required

		pop	af
		pop	hl	;map location
		pop	bc	;driveno
		push	bc
		push	hl
		push	af

		push	hl
		
		ld	a,c
		ld	($5cd6),a
		
		ld	hl,4
		ld	($5cda),hl	; length
		ld	hl,filename
		ld	($5cdc),hl	; pointer to filename

		;rst	8		; Erase if file exists ?
		;defb	24h
		
		rst	8
		defb	22h		; Open temporary 'M' channel (touch)

		xor	a
		rst	8
		defb	21h		; stop microdrive motor

		pop	de
		ld	l,(ix+$1a)	; load address of the associated
		ld	h,(ix+$1b)	; map into the HL register.
		ld	bc,32
		ldir			; copy the map

		rst	8
		defb	2Ch		; Reclaim the channel
		
		ret
