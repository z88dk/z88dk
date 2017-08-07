ESXDOS functions can be called from within esxdos, which applies
to dot commands, or from elsewhere which applies to the usual
programs running from ram.

If esxdos is called from within, then parameters can be passed
in via HL.  Otherwise that same parameter is passed in IX instead.

For this reason, the C interface has two entry points defined - one
for dot commands and one for ram.  All functions carry "dot" or
"ram" in their names to distinguish them.  You can choose to call
the specific function by these names as needed or you can call the
equivalent function without "dot" or "ram" in their names.  The
esxdos header will define these functions appropriately depending
on whether the toolchain is compiling a dot command or not.
