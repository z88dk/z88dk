
	SECTION	rodata_clib
	PUBLIC	keys_cursor
	PUBLIC	keys_qaop
	PUBLIC	keys_vi
	PUBLIC	keys_8246

keys_cursor:
	defw	$1000, $0800, $2000, $4001, $0401, $0000

keys_qaop:
	defw	$8004, $4004, $0201, $8001, $8007, $0407, $0000

keys_vi:
	defw	$4007, $1007, $0807, $2007, $0103, $8006, $0000

keys_8246:
	defw	$2003, $0803, $4003, $4005, $0205, $1003, $0000
