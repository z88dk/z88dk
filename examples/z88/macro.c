/*
 * At Last! Macros for z80asm
 *
 * Short example of how to do macros in Small C, this required a bit
 * of a rewrite of doasmfunc() but I think it needed it, anyway, here's
 * how to do them. Recognise the code?!?! <grin>
 *
 * djm 18/3/99
 */


#define CLEAR(st,len) asm("ld\thl, "#st"\nld\tde,"#st"+1\nld\tbc,"#len"\nld\t(hl),0\nldir\n");



main()
{
	CLEAR(16384,6911)
}
