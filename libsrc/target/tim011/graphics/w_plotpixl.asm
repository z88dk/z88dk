; Plot pixel at (x,y)


	SECTION	code_clib
	PUBLIC	w_plotpixel
	defc	NEEDplot = 1


w_plotpixel:
	INCLUDE	"target/tim011/graphics/pixel.inc"