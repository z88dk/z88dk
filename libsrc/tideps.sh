#!/bin/sh
#  short script to sort out ticalc dependencies

	rm -f stdio/ticalc/fgetc_cons.o
	rm -f stdio/ticalc/getk.o
	rm -f stdio/ticalc/getk_decode.o
	rm -f stdio/ansi/ticalc/f_ansi_attr.o
	rm -f stdio/ansi/ticalc/f_ansi_bel.o
	rm -f stdio/ansi/ticalc/f_ansi_char.o
	rm -f stdio/ansi/ticalc/f_ansi_cls.o
	rm -f stdio/ansi/ticalc/f_ansi_dline.o
	rm -f stdio/ansi/ticalc/f_ansi_scrollup.o
	rm -f graphics/*.o
	rm -f graphics/ticalc/*.o

