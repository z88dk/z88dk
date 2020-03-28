

struct inner {
	int	x;
	char	buf[100];
};


struct outer {
	int	y;
	struct inner inner;
} s;

struct outer *ptr;

int func1() {
    return sizeof(s);
}
int func1a() {
    return sizeof(s.y);
}
int func1b() {
    return sizeof(s.inner);
}
int func1c() {
    return sizeof(s.inner.x);
}
int func1d() {
    return sizeof(s.inner.buf);
}

int func2() {
    return sizeof(*ptr);
}
int func2a() {
    return sizeof(ptr->y);
}
int func2b() {
    return sizeof(ptr->inner);
}
int func2c() {
    return sizeof(ptr->inner.x);
}
int func2d() {
    return sizeof(ptr->inner.buf);
}
