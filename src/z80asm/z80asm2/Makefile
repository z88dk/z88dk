TEMPLATE = mkparser.cpp

parser.cpp : parser.y $(TEMPLATE) mkparser.pl Makefile
	perl mkparser.pl $(TEMPLATE) parser.y
