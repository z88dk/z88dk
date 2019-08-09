


int func(int tcode, int level) {
 return tcode & ((unsigned int)(~0) >> ((sizeof(int) * 8) - level));
}
