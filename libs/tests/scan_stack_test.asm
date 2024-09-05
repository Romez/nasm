global _start

extern scan_stack

section .text

_start:
    push rbp
    mov rbp, rsp

    push 'A'
    push  'B'

    call fn1

    mov rdi, rax
    mov rax, 60
    syscall

fn1:
    push rbp
    mov rbp, rsp

    push 'C'

    call fn2

    mov rsp, rbp
    pop rbp
    ret

fn2:
    push rbp
    mov rbp, rsp

    push 0
    push 22

    mov rdi, fn1
    call scan_stack

    mov rsp, rbp
    pop rbp
    ret
