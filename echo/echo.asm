global _start

section .bss
    buffer resb 3

section .data
    buffer_size equ 3

section .text
    sys_exit  equ 60
    sys_read  equ 0
    sys_write equ 1
    stdin  equ 0
    stdout equ 1

_start:
.read_input:
    ; read input
    mov rax, sys_read
    mov rdi, stdin
    mov rsi, buffer
    mov rdx, buffer_size
    syscall

    ; check \n
    cmp byte [buffer], 10
    je .exit

    ; call buffer handler
    push buffer
    push buffer_size
    call handle_buffer

    sub rax, buffer_size
    js .exit
    
    jmp .read_input

.exit:
    ; print \n
    mov byte [buffer], 10
    mov rax, sys_write
    mov rdi, stdout
    mov rsi, buffer
    mov rdx, 1
    syscall

    ; ----
    mov rax, sys_exit
    mov rdi, 0
    syscall

; param 1: rbp + 16 - buffer size
; param 2: rbp + 24 - buffer address
handle_buffer:
    push rbp
    mov rbp, rsp

    mov r10, 0

.print_buffer:
    mov rax, [rbp + 24]
    cmp byte [rax + r10], 10
    je .exit

    ; print char
    mov rax, sys_write
    mov rdi, stdout
    mov rsi, qword [rbp + 24]
    add rsi, r10
    mov rdx, 1 ; size
    syscall

    inc r10

    cmp r10, qword [rbp + 16]
    je .exit

    jmp .print_buffer
.exit:
    mov rax, 10

    mov rsp, rbp
    pop rbp
    ret 16