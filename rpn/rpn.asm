global _start
extern int_to_ascii

section .bss
    buffer resb 1
    buffer_out resb 64

section .data
    intro db 'Enter expr in reverse polish notation:', 10
    intro_len equ $ - intro

section .text
    sys_exit  equ 60
    sys_read  equ 0
    sys_write equ 1
    stdin  equ 0
    stdout equ 1
_start:
    call print_intro

.read_symbol:
    ; read user input
    mov rax, sys_read
    mov rdi, stdin
    mov rsi, buffer
    mov rdx, 1
    syscall

    test rax, rax
    jz .end_read

    cmp byte [buffer], 10
    je .end_read

    cmp byte [buffer], "+"
    je .add_up

    ; TODO: add ops

    ; check space
    cmp byte [buffer], 0x20
    je .read_symbol

    movzx rax, byte [buffer]
    sub rax, 0x30
    push rax

    jmp .read_symbol

.add_up:
    pop rax
    pop rdx
    add rax, rdx
    push rax

    jmp .read_symbol

.end_read:
    ; result is on stack
    push buffer_out
    call int_to_ascii

    mov rdi, stdout
    mov rsi, buffer_out
    mov rdx, rax
    mov rax, 1
    syscall

    ; ----
    mov rax, sys_exit
    mov rdi, 0
    syscall

print_intro:
    mov rdi, stdout
    mov rsi, intro
    mov rdx, intro_len
    mov rax, 1
    syscall
    
    ret
