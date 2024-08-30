global _start

extern int_to_str

SECTION .data

SECTION .text
    sys_write equ 1
    stdout equ 1
_start:
    mov rdi, -233
    call int_to_str
    ; rax: str ptr
    ; rdx: str len

    mov rsi, rax
    mov rax, sys_write
    mov rdi, stdout
    ; mov rsi, buffer ;addr
    ; mov rdx, 7      ; len
    syscall

    mov rdi, rax
    mov rax, 60
    syscall


; nasm -f elf64 int_to_str_test.asm && ld ../stdlib.o int_to_str_test.o -o int_to_str_test
