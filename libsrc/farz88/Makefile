#
# Makefile for far malloc
#



all:
	zcc -vn -make-lib strings/strdup_far.c
	z80asm -d -ns -nm -Mo -x../farz88 @farz88.lst
