PATH = /demos/*;/games;/games/*;/games/zx81/*

Create a file holding environment variables in:

/sys/env.cfg

Each line in this file can contain a "name = value" pair.
The code that reads this file is robust so there can be errors
and strange formatting.   The file should use unix line endings (\n); 
I think it will be ok with windows \r\n but that is untested.

The important variable is PATH.  Create a path variable inside
env.cfg that holds all the directories you want searched.  It
must be in one line no matter how long it gets.  Each directory
in the path is separated by : or ; .  Backward slashes are ok 
and will be changed to forward, leading and trailing spaces are ok.
Spaces inside a directory name are ok.

PATH = /demos/*;/games;/games/*;/games/zx81/*

A trailing "/*" means the directories contained in that directory
will be searched.  So "/games/*" means all directories in "/games"
will be searched; note it does not mean "/games" itself will be
searched.

.run will automatically locate and run programs with .tap,
sna, .snx, .z80, .o, .p, .nex, .exe (not done) extensions.

It will first try to load the program from the current directory
and if not found, it will search PATH.

Some example usages:


1 .run

prints help

2 .run -p

prints each directory in the PATH.
places an X beside directories that don't exist.

3 .run -? warhawk.sna

prints all directories where "warhawk.sna" is found.
the same name can be in many directories.
the list is numbered - this number can be used
to refer to a specific "warhawk.sna"

4 .run -c warhawk.sna

change to the directory where warhawk.sna is found.

5 .run warhawk.sna

run the first warhawk.sna found

6 .run -2 warhawk.sna

run the second warhawk.sna found

7 .run castlevania.tap

mount castlevania.tap.  directory
will be changed to the location of the tap.
Run with:
LOAD "t:": LOAD ""

8 .run -r castlevania.tap

mount castlevania.tap.  directory is not changed.
Run with:
LOAD "t:": LOAD ""
