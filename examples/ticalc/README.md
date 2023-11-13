# Building for the ti calculator


```bash
zcc +ti82 -o output -create-app input.c

zcc +ti83 -o output -create-app input.c

zcc +ti83p -o output -create-app input.c -subtype=asm

zcc +ti85 -o output -create-app input.c

zcc +ti86 -o output -create-app input.c

zcc +ti83p -o output -create-app input.c -subtype=app_one_page

z88dk-appmake +ti83papp --combine-pages --output out.8xk --other-pages main.bin,page1.bin
```

Click [here](https://github.com/z88dk/z88dk/wiki/Platform---TI-Calculators/b2ff62b304190b96cd3fffa16bc71be4ff3c2c78) for more info.