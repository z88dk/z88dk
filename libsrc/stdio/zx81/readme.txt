Tah-da !!
The ZX81 support.

You can choose between a VT emulation (white text on black background, 
scrolling, ESC sequences) and the (tiny and puny) ROM code (the execution
stops when last line is reached, so do frequent CLS !).
The ANSI VT support still corrupts something on the BASIC memory, so
probably you won't be able to return cleanly to the prompt if you use it.

After compiling you can use the bin2p utility to create a loadable basic 
program with your code included in a rem line.

Such program can be saved on tape also, using the ZXtape utility.
Take your copy at:
	http://edge.edge.net/~krbaker/zxtape.zip

