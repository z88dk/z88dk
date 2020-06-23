
	SECTION		code_graphics

	PUBLIC		generic_console_set_ink
	PUBLIC		generic_console_set_attribute

	EXTERN		__MODE3_attr
	EXTERN		__MODE2_attr

generic_console_set_ink:
	and	15
	ld	(__MODE3_attr),a
	and	3
	ld	(__MODE2_attr),a
generic_console_set_attribute:
	ret
