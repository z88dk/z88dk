
void func(long val, int fd);
void func1(int fd) __z88dk_fastcall;
void func2(long val, int fd) __z88dk_fastcall;
void func3(int fd) __z88dk_fastcall __stdc;
void func4(long val, int fd) __z88dk_fastcall __stdc;

void func1(int fd) {
    func(0L, fd);
}

void func2(long val, int fd) {
    func(val, fd);
}

void func3(int fd) {
    func(0,fd);
}


void callfunc1() {
    func1(10);
}

void callfunc2() {
    func2(1000L, 10);
}

void callfunc3() {
    func3(10);
}
void callfunc4() {
    func4(1000L,10);
}
