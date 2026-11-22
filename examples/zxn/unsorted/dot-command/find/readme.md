# .FIND dot command

To use, copy "FIND" to the sd card's DOT directory.

## Compiling

~~~
zcc +zxn -v -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size @zproject.lst -o find -pragma-include:zpragma.inc -subtype=dotn -Cz"--clean" -create-app
~~~

## Usage

`.find` entered on its own at the basic prompt will print help.

This utility searches directories from the start directory
for a particlar file matching criteria supplied on the command
line.

The help text is reproduced here:

~~~
find - search for files in a
  directory hierarchy

.find DIR [OPTION]...

Find files starting at DIR
that match provided criteria.

Example:

.find . -type=f -name *.txt

(find all files in the current
directory and below that end
in ".txt")

All word options accept single
or double leading hyphens.

CRITERIA

-exec
  file must be an executable
  bas dot nex o p sna snx
  tap z80

-mindepth N, -mindepth=N
  ignore until at least N
  directory levels traversed

-maxdepth N, -maxdepth=N
  ignore if more than N
  directory levels traversed

-mmin N, -mmin=N
  (not implemented yet)

-mtime N, -mtime=N
  (not implemented yet)

-name S, -name=S
  lfn name must match S
  S can contain *? wildcards

-prune S, -prune=S
  ignore directory S
  S can contain *? wildcards
  else S is a canonical name

-size N, -size=N
  if N>0 file must be at least
    N bytes in size
  if N<0 file must be less than
    N bytes in size
  N can have a suffix modifier:
    "b" : * 512
    "c" : * 1
    "w" : * 2
    "k" : * 1024
    "M" : * 1048576

-type T, -type=f, -type=d
  must be a file, directory

DISPLAY

-lfn=on
  print matches with lfn names

-lfn=off
  print matches with 8.3 names

-lfn=both
  print matches w/ both names

ACTION

-cd N, -cd=N
  change to the directory of
  the Nth match and exit

OTHER

-help
  print this help and exit

-version
  print version info and exit

find 1.1 zx-next 128k z88dk.org
~~~

## Examples

1. Locate all exectuables in the current directory and below.
Executables are defined as "nex o p sna snx tap z80" types.

`.find . -exec`

2. Locate the 20th executable and change directory to that.
Use `.run` to run the program.

```
.find . -exec -cd=20
.run castelvania.tap
```

3. Locate all text files between 1k and 10k in size.

`.find . -name *.txt -size 1k -size -10k`

4. Find all games with batman in the name.

`.find . -exec -name *batman*`

Filename matches are only applied against the long filename.
The matching uses wildcards `*` and `?` which can match any
character including `.`
