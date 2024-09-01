.PHONY: rpn

clean:
	rm -f rpn.o \
	rm -f rpn

rpn:
	nasm -f elf64 rpn.asm && ld rpn.o ../libs/stdlib.o -o rpn