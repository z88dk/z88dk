# Makefile to make original z88dk GNU makefiles Borland DOS/Win compatible.
# Substitute "\tcd .. ; ./b.sh" with "\tcd ..\n\tb.bat\n\tcd graphics".
# Substitute "\tcd a ; make b" with "\tcd a\n\tmake b\n\tcd ..".
# Substitute "\t@echo ''" with "\t@echo.".
# Substitute "\t@echo '---> abc <---'" with "\t@echo ---- abc ----".
# Substitute "\t./a.sh" with "\ta.bat".
# Rename original Makefile to GNUmakefile.
# Rename and filter original *.sh to *.bat.
# Works with make from Borland and sed from UnxUtils.
# http://www.borland.com/bcppbuilder/freecompiler/
# http://www.weihenstephan.de/~syring/win32/UnxUtils.html
# This makefile should be named GnuToBor.mak, placed in z88dk and run from there.
# Does not yet handle conversion of z88dk/Makefile.
# Dennis Groning <dennisgr@algonet.se> 30 May 2002.

Z88DKDIR = c:\z88dk

MFILES = \
	$(Z88DKDIR)\Makefile \
#	$(Z88DKDIR)\examples\spectrum\Makefile \
#	$(Z88DKDIR)\examples\z88\Makefile \
#	$(Z88DKDIR)\examples\z88\app\Makefile \
#	$(Z88DKDIR)\examples\z88\app\farmall\Makefile \
	$(Z88DKDIR)\libsrc\Makefile \
#	$(Z88DKDIR)\libsrc\assert\Makefile \
#	$(Z88DKDIR)\libsrc\ctype\Makefile \
	$(Z88DKDIR)\libsrc\farz88\Makefile \
#	$(Z88DKDIR)\libsrc\farz88\strings\Makefile \
	$(Z88DKDIR)\libsrc\fcntl\Makefile \
#	$(Z88DKDIR)\libsrc\fcntl\cpm\Makefile \
	$(Z88DKDIR)\libsrc\fcntl\dummy\Makefile \
	$(Z88DKDIR)\libsrc\fcntl\spectrum\Makefile \
#	$(Z88DKDIR)\libsrc\fcntl\spectrum\plus3\Makefile \
#	$(Z88DKDIR)\libsrc\fcntl\z88\Makefile \
#	$(Z88DKDIR)\libsrc\games\Makefile \
	$(Z88DKDIR)\libsrc\genmath\Makefile \
	$(Z88DKDIR)\libsrc\graphics\Makefile \
	$(Z88DKDIR)\libsrc\malloc\Makefile \
#	$(Z88DKDIR)\libsrc\malloc\strings\Makefile \
#	$(Z88DKDIR)\libsrc\net\Makefile \
#	$(Z88DKDIR)\libsrc\printflike\Makefile \
	$(Z88DKDIR)\libsrc\rex\Makefile \
#	$(Z88DKDIR)\libsrc\rex\farcall\Makefile \
#	$(Z88DKDIR)\libsrc\rex\graphics\Makefile \
	$(Z88DKDIR)\libsrc\rs232\Makefile \
	$(Z88DKDIR)\libsrc\rs232\Spectrum\Makefile \
#	$(Z88DKDIR)\libsrc\rs232\Spectrum\if1\Makefile \
#	$(Z88DKDIR)\libsrc\rs232\Spectrum\plus3\Makefile \
#	$(Z88DKDIR)\libsrc\rs232\z88\Makefile \
#	$(Z88DKDIR)\libsrc\setjmp\Makefile \
#	$(Z88DKDIR)\libsrc\spectrum\Makefile \
	$(Z88DKDIR)\libsrc\stdio\Makefile \
	$(Z88DKDIR)\libsrc\stdio\8080\Makefile \
#	$(Z88DKDIR)\libsrc\stdio\z88\Makefile \
	$(Z88DKDIR)\libsrc\stdio\zsock\Makefile \
	$(Z88DKDIR)\libsrc\stdlib\Makefile \
#	$(Z88DKDIR)\libsrc\stdlib\spectrum\Makefile \
#	$(Z88DKDIR)\libsrc\stdlib\z88\Makefile \
#	$(Z88DKDIR)\libsrc\strings\Makefile \
	$(Z88DKDIR)\libsrc\time\Makefile \
#	$(Z88DKDIR)\libsrc\time\spectrum\Makefile \
#	$(Z88DKDIR)\libsrc\time\z88\Makefile \
#	$(Z88DKDIR)\libsrc\z80_crt0s\Makefile \
	$(Z88DKDIR)\libsrc\z88\Makefile \
#	$(Z88DKDIR)\libsrc\z88\fdstdio\Makefile \
#	$(Z88DKDIR)\libsrc\z88math\Makefile \
#	$(Z88DKDIR)\src\appmake\Makefile \
#	$(Z88DKDIR)\src\copt\Makefile \
#	$(Z88DKDIR)\src\cpp\Makefile \
#	$(Z88DKDIR)\src\sccz80\Makefile \
#	$(Z88DKDIR)\src\z80asm\Makefile \
#	$(Z88DKDIR)\src\zcc\Makefile \
	$(Z88DKDIR)\support\bogomips\Makefile

SFILES = \
	gamesdeps.sh \
	gfxdeps.sh \
	tideps.sh

.path.sh  = $(Z88DKDIR)\libsrc
.path.bat = $(Z88DKDIR)\libsrc


All: ToBor $(SFILES:.sh=.bat)

ToBor: $(MFILES)
	&$(MAKE) -f GnuToBor.mak -DDIR=$(?D) -DTARGET=Makefile.mak ChangeDir

UnBor: $(MFILES:Makefile=GNUmakefile)
	- &$(MAKE) -f GnuToBor.mak -DDIR=$(?D) -DTARGET=Makefile ChangeDir

ChangeDir:
	cd $(DIR)
	$(MAKE) -f $(Z88DKDIR)\GnuToBor.mak -DDIR=$(DIR) $(TARGET)

Makefile.mak: Makefile
	sed -f &&|
s/^^\([^	 ]\+cd[^	 ]\+..\)\/[^	 ]*;[^	 ]*\(.*\)/\1\\
^	\2\\
^	cd graphics/
| < Makefile > Makefile.1
	sed -f &&|
s/^^\([^	 ]\+cd[^	 ]\+[^^^	 ]\+\)[^	 ]*;[^	 ]*\(.*\)/\1\\
^	\2\\
^	cd ../
| < Makefile.1 > Makefile.2
	sed "s/^\([	 ]\+@echo\)[	 ]\+''/\1./" < Makefile.2 > Makefile.3
	sed "s/^\([	 ]\+@echo[	 ]\+\)'--->\(.*\)<---'/\1----\2----/" < Makefile.3 > Makefile.4
	sed "s/^\([	 ]\+\).\/\(.\+\).sh/\1\2.bat/" < Makefile.4 > Makefile.mak
    del Makefile.1
	del Makefile.2
	del Makefile.3
	del Makefile.4
	- ren Makefile GNUmakefile

Makefile:
	- ren GNUmakefile Makefile
	- del Makefile.mak

.sh.bat:
	sed "s/^[	 ]*#.*//" < $*.sh > $*.bat
