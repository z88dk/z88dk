for /R %%x in (*.asm) do (
   type %%x | sed -r "s/([ \t]*)XLIB[ \t]/\1PUBLIC /g" | sed -r "s/([ \t]*)LIB[ \t]/\1EXTERN /g" | sed -r "s/([ \t]*)XREF[ \t]/\1EXTERN /g" | sed -r "s/([ \t]*)XDEF[ \t]/\1PUBLIC /g" > temp.tmp
   copy /Y temp.tmp %%x
)
del temp.tmp
