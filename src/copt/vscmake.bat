cl /Fecopt /Iregex -DUSE_REGEXP -DLOCAL_REGEXP *.c regex\reg*.c
move copt.exe ..\..\bin
del *.obj
