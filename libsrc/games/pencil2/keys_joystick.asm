
	SECTION	rodata_clib
	PUBLIC	keys_cursor
	PUBLIC	keys_qaop
	PUBLIC	keys_vi
	PUBLIC	keys_8246

keys_cursor:
	defw	$0200, $0800, $0400, $0100, $0103, $0402, $0000

keys_qaop:
	defw	$0403, $0203, $0206, $0104, $0801, $4001, $0000

keys_vi:
	defw	$0205, $4002, $0101, $0805, $0406, $0806, $0000

keys_8246:
	defw	$4004, $2003, $0208, $0807, $0407, $2004, $0000
