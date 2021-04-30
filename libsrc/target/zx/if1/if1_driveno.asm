;
;	ZX IF1 & Microdrive functions
;
;	int if1_driveno(char *fname);
;	char *if1_filename(char *fname);
;
;	Extract the drive number from the specified filename
;
;	$Id: if1_driveno.asm $
;

      SECTION code_clib
      PUBLIC	if1_driveno
      PUBLIC   _if1_driveno
      PUBLIC   if1_filename
      PUBLIC   _if1_filename

      PUBLIC   if1_default_drv
      PUBLIC   _if1_default_drv
	  
	  EXTERN   asm_isdigit
	  EXTERN   asm_toupper

if1_filename:
_if1_filename:

; __FASTCALL__
	inc hl
	ld	a,(hl)
	dec hl
	cp ':'
	ret nz
	inc hl
	inc hl
	ret


if1_driveno:
_if1_driveno:

; __FASTCALL__
	inc hl
	ld	a,(hl)
	cp ':'
	ld	a,(if1_default_drv)
	jr	nz,driveno_ret
	
	dec hl
	ld	a,(hl)
	call asm_isdigit
	jr	c,get_letter	; carry set if not decimal digit
	sub '0'
	jr driveno_ret
	
get_letter:
	call asm_toupper
	sub 'A'-1
		
driveno_ret:
	ld	h,0
	ld	l,a
	ret


		SECTION data_clib
if1_default_drv:
_if1_default_drv:
		defw 1
