
	MODULE	generic_console_ioctl
	PUBLIC	generic_console_ioctl

	SECTION	code_clib
	INCLUDE	"ioctl.def"

	EXTERN	copy_font_gemini
	EXTERN	generic_console_cls
	EXTERN	__gemini_mode
	EXTERN	__console_h
	EXTERN	__console_w
	EXTERN	__gemini_custom_font

	EXTERN		putvid_a
	EXTERN		generic_console_cls


        PUBLIC          CLIB_GENCON_CAPS
        defc            CLIB_GENCON_CAPS =  CAP_GENCON_CUSTOM_FONT | CAP_GENCON_UDGS

; a = ioctl
; de = arg
generic_console_ioctl:
	ex	de,hl
	ld	c,(hl)	;bc = where we point to
	inc	hl
	ld	b,(hl)
	cp	IOCTL_GENCON_SET_FONT32
	jr	nz,check_set_udg
	ld	a,c
	or	b
	ld	(__gemini_custom_font),a
	jr	z,success
;---------------------------------
	ld	e,c
	ld	d,b
	ld  c,96
	ld  hl,8
	ld  a,' '
	call copy_font_gemini
;---------------------------------
success:
	and	a
	ret

check_set_udg:
	cp	IOCTL_GENCON_SET_UDGS
	jr	nz,check_mode
;---------------------------------
	ld	e,c
	ld	d,b
	ld  c,128 - 32
	ld  hl,8
	ld  a,128 + 32
	jp copy_font_gemini
;---------------------------------

check_mode:
	cp	IOCTL_GENCON_SET_MODE
	jr	nz,failure

	ld	a,c
    ; 1 = mode 1 (80 columns)
    ; 2 = mode 2 (40 columns)  ..on a GM812 board it is 48 columns, text will be shifted on the left
    ; 3 = mode 3 (user defined)
    ; 4 = mode 4 (256x256 graphics)   .. this will work on GM832 only.

; | 80 col | 40 col | 48 col | Graph. |
; |   6F   |   37   |   4C   |   37   |  ; Horizontal total characters -1
; |   50   |   28   |   30   |   20   |  ; Horizontal displayed characters
; |   58   |   2E   |   3C   |   2B   |  ; Horizontal sync pos. -1
; |   7F   |   77   |   79   |   45   |  ; Vsync/Hsync width
; |   1E   |   1E   |   1E   |   12   |  ; V. character lines total -1
; |   02   |   02   |   02   |   08   |  ; V. scan lines adj. (raster lines)
; |   19   |   19   |   19   |   10   |  ; V. displayed character lines
; |   1B   |   1B   |   1B   |   11   |  ; V. sync position
; |   40   |   40   |   40   |   00   |	 ; Interlace and skew: 40 on GM832, A0 on GM812, 00 in GFX mode
; |   09   |   09   |   09   |   0F   |  ; Rasters oer character line -1
; |   48   |   48   |   48   |   48   |  ; Cursor type & start raster
; |   08   |   08   |   08   |   08   |  ; Cursor end raster


	ld	l,80
	ld	h,25
	cp	1
	jr	z,set_mode
	cp	3	; TODO: user defined modes
	jr	z,set_mode
	ld	l,40
	ld	h,25
	cp	2
	jr	z,set_mode
	ld	l,32
	ld	h,25
	cp	4
	jr	nz,failure

set_mode:
	ld	(__console_w),hl
	ld	(__gemini_mode),a
	ld  c,a
	ld  a,27
	call putvid_a
	ld  a,c
	add '0'
	call putvid_a
	call generic_console_cls
	jr	success

failure:
	scf
dummy_return:
	ret


