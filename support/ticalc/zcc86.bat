rem $Id: zcc86.bat,v 1.3 2001-10-27 13:20:15 stefano Exp $
zcc %1.c
del %1
ren a.bin %1
prgm86 %1
