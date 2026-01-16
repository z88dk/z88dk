# .RUN dot command

RUN searches a path to locate and execute a program with filename
matching the criteria.

The PATH is held in an environment variable stored in file
`/sys/env.cfg`.  It has the following form:

~~~
PATH = /demos/*;/games;/games/*;/games/zx81/*
~~~

Each line in `env.cfg` can contain a `name = value` pair.
The code that reads this file is robust so there can be errors
and strange formatting but it is important that PATH is
contained entirely in one line no matter how long it gets.

PATH is a list of directories that should be searched to
locate executables.  Each directory is separated by a `;`.
Backward slashes are ok and will be changed to forward, leading
and trailing spaces are ok.  Spaces inside names are ok.

A trailing `/*` means all the directories contained in that directory
will be searched.  So `/games/*` means all directories in `/games`
will be searched; note it does not mean `/games` itself will be
searched and that is why you will see both `/games` and `/games/*`
in the example above.

RUN will match the filename it is given against the contents of
directories in the PATH and automatically launch the program.  It
will always search the current directory before those listed in
PATH.  The filename can contain wildcards.

Options allow listing of all filename matches and executing
matches other than the first.

Programs having the following extensions are identified as executable:

~~~
bas, dot, nex, o, p, sna, snx, tap, z80
~~~

## Compiling

~~~
zcc +zxn -v -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size @zproject.lst -o run -pragma-include:zpragma.inc -subtype=dot-n -Cz"--clean" -create-app
~~~

## Usage

The help text is reproduced here:

~~~
.run [OPTIONS] FILE

supported extensions:  bas
dot nex o p sna snx tap z80

options:

-p = list dirs in PATH
-? = list FILE matches
-c = cd to FILE location
-r = retain cwd on clean exit
-N = select Nth FILE match

run 1.4 zx-next z88dk.org
~~~

## Examples

1. `.run`

Prints help.

2. `.run -p`

Lists each directory in the PATH.<br>
Places an X beside directories that don't exist.

3. `.run -? war*`

Lists all executables matching `war*`.<br>
The list is numbered so that a particular match can be referred to.

4. `.run -c warhawk.nex`

Change to the directory where warhawk.nex is found.

5. `.run warhawk.nex`

Run the first warhawk.nex found

6. `.run -2 warhawk.nex`

Run the second warhawk.nex found

7. `.run castle*.tap`

(Assume "castlevania.tap" exists and is the first match)

Mount castlevania.tap.<br>
The directory will be changed to the location of the tap.

Run with:

`LOAD "t:": LOAD ""`

8. `.run -r castlevania.tap`

Mount castlevania.tap.<br>
The current working directory will not be changed.

Run with:

`LOAD "t:": LOAD ""`

9. `.run -? *batman*`<br>
   `.run -5 *batman*`

List all executables with `batman` in their names.<br>
Run the 5th match from that list.

## Notes

1. When loading tap files, the computer will load in the current mode.  That is, in standard 128k mode if in nextzxos, usr 0 mode if you have entered usr 0 mode and 48k mode if you have entered 48k mode.  This is the same as how other zx machines take care of tape loading but it is different from nextzxos's file browser which will come up with a menu allowing you to select which mode to use before mounting the tap file.

2. You may have to change some settings prior to running a program for some programs that rely on precise video timing or other factors.  For nirvana games, contention must be enabled before running (and besides that your display must be 50Hz VGA to achieve precise timing).  At the time of writing the only way to turn on contention is to do it via basic or the nmi menu but look out for a `.reset` dot command in the future.  To do it via the nmi menu, press the M1 button on the left side of the next; it will be the button closest to you and closest to the bottom where the joystick ports are.  From the menu choose "debug tools" then "status".  With the arrow keys navigate to nextreg 8 and make sure bit 6 is rest in the value there.  If it isn't, press caps+1 and enter a new two-digit hex value which is the same but with bit 6 reset.  Then return to basic by pressing 'c'.  Contention will now be enabled.
