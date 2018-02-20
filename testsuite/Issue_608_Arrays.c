

char carray[] = "HelloThere";
long larray[] = { 1 ,2, 3 };

long larrays[3] = { 1, 2 };

int narray[][3] = {
   { 1, 2 },
   { 3, 4 }
};

int func(int i) {
   return carray[i];
}

int func2(int i) {
  return larray[i];
}

int func2_b(int i) {
  return larrays[i];
}

int func3(int i) {
   return narray[i][1];
}
