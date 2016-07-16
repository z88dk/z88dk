This directory is for implementing STLplus as a single, monolithic library.

For Visual Studio 2010/2012, just build the solution
ide/vs201x/stlplus3_monolithic.sln. This will automatically copy the
source files into here and build the library.

For other compilers, run make_monolithic to import all the source files into
this directory, then build it using your compiler of choice.

Run unmake_monolithic to clear the directory again. You may need to make clean
or use your IDE to clean up object files etc. as well.
