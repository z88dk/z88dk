extern void test(const char *);

void initialize_challenges(unsigned char index, signed char initial_x, signed char initial_y) {
    if ( initial_x < 1 ) {
        test("Hello\n");
     }
}

int main(int argc, char *argv) {
    initialize_challenges(1, 0, 14);
}
