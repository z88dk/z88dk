
	SECTION	data_clib
	PUBLIC	generic_console_flags

generic_console_flags:          defb    0               ; bit 0 = raw mode enabled
                                                        ; bit 2 = blink (not set by us)
                                                        ; bit 3 = underline
                                                        ; bit 4 = bold
                                                        ; bit 6 = vscroll disabled
                                                        ; bit 7 = inverse on
