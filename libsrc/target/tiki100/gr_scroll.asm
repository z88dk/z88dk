;
;	More TIKI-100 graphics routines
;	by Frode van der Meeren
;
; void __FASTCALL__ gr_vscroll(int lines)
; void __FASTCALL__ gr_vscroll_abs(int lines)
;
; Scroll display any number of lines, or set it to
; an absolute line number.
;
;	Changelog:
;
;	v1.0 - FrodeM
;	   * Added relative and absolute vertical positioning/scroll 
;
;	$Id: gr_scroll.asm,v 1.2 2016-06-10 23:01:47 dom Exp $
;

	SECTION code_clib
PUBLIC gr_vscroll
PUBLIC _gr_vscroll
PUBLIC gr_vscroll_abs
PUBLIC _gr_vscroll_abs

gr_vscroll:
_gr_vscroll:
	ld	b,a
	ld	a,$0E
	out	($16),a
	in	a,($17)
	sub	b
	out	($17),a
	RET

gr_vscroll_abs:
_gr_vscroll_abs:
	ld	b,a
	ld	a,$0E
	out	($16),a
	ld	a,b
	out	($17),a
	RET
