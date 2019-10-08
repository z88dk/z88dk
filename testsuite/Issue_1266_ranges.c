
long land_test1(long t) {
   return t & 0x7000;
}

long land_test2(long t) {
   return t & 0x70;
}

long land_test3(long t) {
   return t & 0x700000;
}

long land_test4(long t) {
   return t & 0x70000000;
}

int iand_test1(int t) {
   return t & 0x7000;
}

int iand_test2(int t) {
   return t & 0x70;
}


long lor_test1(long t) {
   return t | 0x7000;
}

long lor_test2(long t) {
   return t | 0x70;
}

long lor_test3(long t) {
   return t | 0x700000;
}

long lor_test4(long t) {
   return t | 0x70000000;
}

long lxor_test1(long t) {
   return t ^ 0x7000;
}

long lxor_test2(long t) {
   return t ^ 0x70;
}

long lxor_test3(long t) {
   return t ^ 0x700000;
}

long lxor_test4(long t) {
   return t ^ 0x70000000;
}

