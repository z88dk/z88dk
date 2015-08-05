gcc      -Wall -fomit-frame-pointer -O2 -DALLEGRO_STATICLINK -Ial4include -static   -c -o csp2sgz.o csp2sgz.c
gcc      -s -o csp2sgz csp2sgz.o -lz liballegro-4.4.2-static-mt.a -lwinmm -lshlwapi -lpsapi -lopengl32 -lgdi32 -lsupc++ -lole32 -lgdiplus -luuid -lcomdlg32 lib*.a
