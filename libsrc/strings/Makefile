#
# Wahey, a messed up makefile for building libraries!
#


all: string

string:
	zcc -vn -make-lib memset.c
	zcc -vn -make-lib memcpy.c
	zcc -vn -Wn43 -make-lib strspn.c
	zcc -vn -Wn43 -make-lib strupr.c
	zcc -vn -Wn43 -make-lib strlwr.c
	zcc -vn -Wn43 -make-lib strrstrip.c
	zcc -vn -Wn43 -make-lib strstr.c
	zcc -vn -Wn43 -make-lib strpbrk.c
	zcc -vn -Wn43 -make-lib strpos.c
	zcc -vn -Wn43 -make-lib strcspn.c
	zcc -vn -Wn43 -make-lib strchr.c
	zcc -vn -Wn43 -make-lib strrchr.c


clean:
	rm -f *.sym *.map zcc_opt.def *.o*
