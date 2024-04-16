all: msxmapper.c memoryman.c mallocfar.s
	zcc +msx -subtype=msxdos2  -o memoryman.com msxmapper.c memoryman.c mallocfar.s -D__MMAN_TEST__ -DAMALLOC  -pragma-define:CRT_MAX_HEAP_ADDRESS=0x7fff -lm

clean:
	rm -f *~ *.com
