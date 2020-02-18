
	SECTION	rodata_clib
	PUBLIC	keys_cursor
	PUBLIC	keys_qaop
	PUBLIC	keys_vi
	PUBLIC	keys_8246

keys_cursor:
	defw	$4000, $1000, $8000, $2000, $0400, $8007, $0000, $0000

keys_qaop:
	defw	$0106, $8005, $0204, $0206, $2005, $4005, $0000, $0000

keys_vi:
	defw	$1005, $0105, $0405, $0805, $0806, $1004, $0000, $0000

keys_8246:
	defw	$4002, $1002, $0402, $0103, $0102, $2002, $0000, $0000
