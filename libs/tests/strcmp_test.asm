global _start

extern strcmp
extern print_number

SECTION .data
    s1 db 'abc', 0
    s2 db 'abc', 0

SECTION .text
_start:
    mov rdi, s1
    mov rsi, s2
    call strcmp

    mov rdi, rax
    call print_number

    mov rdi, rax
    mov rax, 60
    syscall

; nasm -f elf64 strlen_test.asm && ld stdlib.o strlen_test.o -o strlen_test
