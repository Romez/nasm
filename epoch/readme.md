print current epoch time in console

build:
nasm -g -f elf64 epoch.asm
ld-o epoch epoch.o
