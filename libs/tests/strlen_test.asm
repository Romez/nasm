global _start

extern strlen

SECTION .data
    s db '', 0

SECTION .text
_start:
    mov rdi, s
    call strlen

    mov rdi, rax
    mov rax, 60
    syscall

; nasm -f elf64 strlen_test.asm && ld stdlib.o strlen_test.o -o strlen_test
