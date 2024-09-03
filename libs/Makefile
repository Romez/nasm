.PHONY: stdlib int_to_str_test

clean:
	rm *.o \
	rm stdlib \
	rm -f ./tests/*.o \
	rm ./tests/int_to_str_test \
	rm ./tests/strlen_test \
	rm ./tests/print_number_test \
	rm ./tests/str_to_int_test

stdlib:
	nasm -g -f elf64 stdlib.asm

scan_stack:
	nasm -g -f elf64 scan_stack.asm

int_to_str_test: stdlib
	nasm -g -f elf64 ./tests/int_to_str_test.asm && ld stdlib.o ./tests/int_to_str_test.o -o ./tests/int_to_str_test

str_to_int_test: stdlib
	nasm -g -f elf64 ./tests/str_to_int_test.asm && ld stdlib.o ./tests/str_to_int_test.o -o ./tests/str_to_int_test
	
strlen_test: stdlib
	nasm -f elf64 ./tests/strlen_test.asm && ld stdlib.o ./tests/strlen_test.o -o ./tests/strlen_test

print_number_test: stdlib
	nasm -f elf64 ./tests/print_number_test.asm && ld stdlib.o ./tests/print_number_test.o -o ./tests/print_number_test

strcmp_test: stdlib
	nasm -f elf64 ./tests/strcmp_test.asm && ld stdlib.o ./tests/strcmp_test.o -o ./tests/strcmp_test

scan_stack_test: scan_stack
	nasm -g -f elf64 ./tests/scan_stack_test.asm && ld scan_stack.o ./tests/scan_stack_test.o -o ./tests/scan_stack_test