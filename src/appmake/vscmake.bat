cl /Feappmake -D__WIN32__ *.c
move appmake.exe ..\..\bin
del *.obj
