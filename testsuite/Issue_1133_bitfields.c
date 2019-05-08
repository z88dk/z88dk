struct {
        signed int      a:11;
        signed int      :5;
        int     b:3;
        int     c:5;
        char    *ptr;
} x = { -1, 3, 15, "hello" };


int func1()  {
        int     z;
        x.a = -1;
        x.b = 2;
        x.c = 3;

        z = sizeof(x);
        z = x.a;
        return z;
}
int func1a() { return x.a; }
int func1b() { return x.b; }
int func1c() { return x.c; }


struct {
	int	a:8;
	signed int	b:8;
} y;
int func2() {
	y.a = 1;
}
int func2a() { return y.a; }
int func2b() { return y.b; }

struct {
	int	a:16;
	signed int b:16;
} z = { 32768};

int func3() {
	z.a = 3;
	return sizeof(z);
}
int func3a() { return z.a; }
int func3b() { return z.b; }

struct {
	int	a:2;
	signed int b:3;
} t4 = { 2, 3 };

int func4() {
	t4.a = 2;
	t4.b = 2;
	return sizeof(t4);
}

int func4a() { return t4.b; }
int func4b() { return t4.a; }


