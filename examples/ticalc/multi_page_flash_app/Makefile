
all:build.8xk

clean:
	$(RM) *.bin *.map *.8xk

main.bin: main.c
	zcc +ti83p main.c -o main.bin -subtype=app_first_page

page1.bin : page1.c
	zcc +ti83p page1.c -o page1.bin -subtype=app_sub_page


build.8xk: main.bin page1.bin
	z88dk-appmake +ti83papp --combine-pages --output out.8xk --other-pages main.bin,page1.bin

	rm *.map *.bin
