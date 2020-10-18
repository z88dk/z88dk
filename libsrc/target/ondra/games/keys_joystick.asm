
	SECTION	rodata_clib
	PUBLIC	keys_cursor
	PUBLIC	keys_qaop
	PUBLIC	keys_vi
	PUBLIC	keys_8246

	; Joysticks run: qaop, 8246, vi, cursor
	; This machine doesn't have number keys, so we just
	; rejiggle them

	defc	keys_qaop = k_qaop
	defc	keys_8246 = k_cursor
	defc	keys_vi = k_vi


k_cursor:
	defw	$1008, $0208, $0408, $0407, $1005, $0103, $0000, $0000

k_qaop:
	defw	$1006, $0406, $1001, $1000, $0207, $0107, $0000, $0000


k_vi:
	defw	$0405, $0805, $0105, $0205, $0401, $0201, $0000, $0000

; Not supported
keys_cursor:
