rem $Id: zcc82.bat,v 1.2 2001-04-17 09:48:30 stefano Exp $
zcc %1.c
del %1.obj
ren a.bas %1.obj
CRPRGM82 %1
