global str_to_int

SECTION .text

str_to_int:
    push rbp
    mov rbp, rsp

    sub rsp, 32
    mov qword [rbp - 8], 0 ; acc
    mov qword [rbp - 16], 0 ; len
    mov qword [rbp - 24], 1 ; mul
    mov qword [rbp - 32], 10 ; base

    push rcx
    ; ----

.loop.push:
    ; push char
    mov rax, qword [rbp + 16] ; str addr
    movzx rax, byte [rax] ; char
    sub rax, 0x30
    push rax

    inc qword [rbp + 16] ; mov addr
    inc qword [rbp - 16] ; len
    
    mov rax, qword [rbp + 16]
    cmp byte [rax], 0
    jnz .loop.push

    mov rcx, 0
.loop.pop:
    pop rax
    mul qword [rbp - 24]
    add qword [rbp - 8], rax ; add to acc

    ; inc multiplier
    mov rax, qword [rbp - 24]
    mul qword [rbp - 32]
    mov qword [rbp - 24], rax

    inc rcx
    cmp rcx, qword [rbp - 16]
    jnz .loop.pop

    mov rax, [rbp - 8]

    ; -----

    pop rcx
    add rsp, 32

    leave
    ret 8