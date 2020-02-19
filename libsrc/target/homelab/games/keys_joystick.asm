
	SECTION	rodata_clib
	PUBLIC	keys_cursor
	PUBLIC	keys_qaop
	PUBLIC	keys_vi
	PUBLIC	keys_8246

keys_cursor:
	defw	$0400, $0800, $0100, $0200, $0201, $0101, $0000, $0000

keys_qaop:
	defw	$010d, $020c, $0208, $020d, $080b, $010c, $0000, $0000

keys_vi:
	defw	$040b, $040a, $010b, $020b, $080d, $0209, $0000, $0000

keys_8246:
	defw	$0405, $0105, $0404, $0106, $0104, $0205, $0000, $0000
