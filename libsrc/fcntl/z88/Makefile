#
# Wahey, a messed up makefile for building libraries!
#



z88_fcntl:
	zcc -vn -make-lib close.c
	zcc -vn -make-lib creat.c
	zcc -vn -make-lib lseek.c
	zcc -vn -make-lib open.c
	zcc -vn -make-lib open_z88.c
	zcc -vn -make-lib nropen.c
	zcc -vn -make-lib read.c
	zcc -vn -make-lib write.c
	zcc -vn -make-lib writebyte.c
	zcc -vn -make-lib readbyte.c
	zcc -vn -make-lib stat.c
	zcc -vn -make-lib opendor.c
	zcc -vn -make-lib readdor.c
	zcc -vn -make-lib closedor.c
	zcc -vn -make-lib writedor.c
	zcc -vn -make-lib deletedor.c
	zcc -vn -make-lib sondor.c
	zcc -vn -make-lib brotherdor.c


clean:
	rm -f  *.sym *.map zcc_opt.def *.o*
