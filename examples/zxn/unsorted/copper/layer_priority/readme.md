## Compile

```
zcc +zxn -vn -startup=31 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 @zproject.lst -o terms -pragma-include:zpragma.inc -subtype=nex -Cz"--clean" -create-app
```

## Run

Both `terms.sna` and `girl.nxi` must be present in the same directory on sd card.
Start the snapshot with `SPECTRUM terms.sna` or `.snapload terms.sna`.

During execution hold 's' until the scrolling stops and then release to change cpu speed.

There is no way to exit the program as of now; you'll have to reset.
