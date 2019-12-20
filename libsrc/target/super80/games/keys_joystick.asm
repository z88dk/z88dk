
	SECTION	rodata_clib
	PUBLIC	keys_cursor
	PUBLIC	keys_qaop
	PUBLIC	keys_vi
	PUBLIC	keys_8246

keys_cursor:
	defw	$8004, $8005, $8006, $8007, $4000, $0000

keys_qaop:
	defw	$0400, $0207, $0101, $0401, $0205, $0206, $0000

keys_vi:
	defw	$0204, $0200, $0202, $0203, $0403, $0104, $0000

keys_8246:
	defw	$1005, $1003, $1001, $1007, $2007, $1004, $0000
