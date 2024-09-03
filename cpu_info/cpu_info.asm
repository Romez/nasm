global _start

section .bss
    info resb 13

section .data

section .text
    sys_exit  equ 60
    sys_write equ 1
    stdout equ 1

_start:
    xor rax, rax
    cpuid

    ; ebx, edx, ecx
    mov dword [info], ebx
    mov dword [info + 4], edx
    mov dword [info + 8], ecx

    mov byte [info + 12], 10

    ; print
    mov rax, sys_write
    mov rdi, stdout
    mov rsi, info
    mov rdx, 13
    syscall

    ; epilog
    mov rax, sys_exit
    mov rdi, 0
    syscall