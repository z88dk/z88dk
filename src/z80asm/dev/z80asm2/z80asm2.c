#include <stdio.h>
#include <stdlib.h>
#include "frontend.h"

int main(int argc, char* argv[]) {
	if (argc != 2) {
		fputs("Expected source file", stderr);
		exit(EXIT_FAILURE);
	}
	else {
		if (!assemble_file(argv[1])) exit(EXIT_FAILURE);
	}
}
