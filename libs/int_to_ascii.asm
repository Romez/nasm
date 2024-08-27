global int_to_ascii

SECTION .text

int_to_ascii:
    push rbp
    mov rbp, rsp

    push rsi

    ; ------

    sub rsp, 16
    mov qword [rbp - 8], 0 ; num len
    mov qword [rbp - 16], 10 ; base of 10

    mov rsi, [rbp + 16] ; buffer
    mov rax, [rbp + 24] ; num param

    ;; if neg
    test rax, rax
    js .is_negative
    jmp .push_loop

.is_negative:
    neg rax
    mov [rsi], byte "-"
    inc rsi
    inc qword [rbp - 8]

.push_loop:
    xor rdx, rdx
    div qword [rbp - 16]

    push rdx

    inc qword [rbp - 8]
    cmp rax, 0

    jnz .push_loop
    mov rdx, [rbp - 8]

.pop_loop:
    pop rax
    add rax, 0x30

    mov [rsi], rax
    inc rsi

    dec qword [rbp - 8]
    cmp qword [rbp - 8], 0
jnz .pop_loop

    mov rax, rdx

    ; --------
    add rsp, 16

    pop rsi

    mov rsp, rbp
    pop rbp
    ret 16