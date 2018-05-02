regex project
-----------

Build 20:11 2017-08-07 - forked github.com/garyhouston/regex

Needed a stable WIN32 source and build of regex, to include in other projects.

Added a CMake - CMakeLists.txt - build. Depending on the MSVC version installed, should be able to use the build-me.bat in the `build` folder. But if not the command line steps are simple -

```
> cd build
> cmake .. [options]
> cmake --build . --config Release
```

This should get the static `regex.lib`, and a `re-test.exe` built. Note, the `re-test` app has not been tested in Windows...

The previous Makefile instructions are left below, but are unlikely to work in a native Windows MSVC build environment...

Previous OLD README:
--------

Was alpha3.8 release. Tue Aug 10 15:51:48 EDT 1999 henry@spsystems.net  (formerly henry@zoo.toronto.edu)

See WHATSNEW for change listing.

Read the comments at the beginning of Makefile before running.

Utils.h contains some things that just might have to be modified on
some systems, as well as a nested include (ugh) of <assert.h>.

The "fake" directory contains quick-and-dirty fakes for some header
files and routines that old systems may not have.  Note also that
-DUSEBCOPY will make utils.h substitute bcopy() for memmove().

After that, "make r" will build regcomp.o, regexec.o, regfree.o,
and regerror.o (the actual routines), bundle them together into a test
program, and run regression tests on them.  No output is good output.

"make lib" builds just the .o files for the actual routines (when
you're happy with testing and have adjusted CFLAGS for production),
and puts them together into libregex.a.  You can pick up either the
library or *.o ("make lib" makes sure there are no other .o files left
around to confuse things).

Main.c, debug.c, split.c are used for regression testing but are not part
of the RE routines themselves.

Regex.h goes in /usr/include.  All other .h files are internal only.

; eof
