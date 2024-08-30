global _start

extern str_to_int

SECTION .data
    s db '222'

SECTION .text
    sys_write equ 1
    stdout equ 1
_start:
    mov rdi, s
    call str_to_int
    ; rax

    mov rdi, rax
    mov rax, 60
    syscall
