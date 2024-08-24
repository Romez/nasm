.PHONY: countdown

countdown:
	nasm -g -f elf64 countdown.asm && ld countdown.o ../libs/int_to_ascii.o ../libs/str_to_int.o -o countdown