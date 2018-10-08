# Z88dk PC-G850 monographics example

The examples for g800 monographics. Tested on [g800] emulator and PC-G850V.

| filename         | description                                               |
| ---------------- | --------------------------------------------------------- |
| box.c            | Writing random boxes                                      |
| mandel.c         | Mandelbrot set plot, copied from example/graphics folder  |
| physics.c        | Random ball physics simulation                            |
| sin.c            | Plot sin wave                                             |
| turtle.c         | Turtle graphics library                                   |
| turtle_example.c | Turtle graphics example                                   |

## Build and run on the emulator

To build all intelhex(ihx) files:

```
make
```

To run ihx files on the [g800](http://ver0.sakura.ne.jp/pc/) emulator:

```
./run.sh sin.ihx
```

The path of [g800](http://ver0.sakura.ne.jp/pc/) binary should be exist in your PATH.

## Transfer to a real machine

To transport ihx files to a real PC-G850 machine:

```
./send.py sin.ihx
```

You need python3, pyserial and IntelHex modules. You should modify COM_DEVICE line in the head of the script.

And of course, you need a connection cable. My recomendataion is [this one](http://www.charatsoft.com/software/pocket-computer/usb_serial.html).

## Comments

- Function getk() returns not 13 but 10 when enter key is pressed.
- Under clib=850, getk() blocks but under clib=850b it doesn't block.
