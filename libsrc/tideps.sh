#!/bin/sh
#  $Id: tideps.sh,v 1.7 2001-10-27 13:20:15 stefano Exp $
#  short script to sort out ticalc dependencies

	rm -f stdio/ticalc/*.o
	rm -f stdio/ansi/ticalc/*.o
	rm -f games/*.o
	rm -f games/ticalc/*.o
	rm -f graphics/*.o
	rm -f graphics/ticalc/*.o
	rm -f graphics/gray/*.o
	rm -f graphics/gray/ticalc/*.o
