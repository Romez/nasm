global scan_stack

; param 1 ; rdi ; number ; 8 bytes
scan_stack:
    mov rcx, rsp
    sub rcx, rbp
    add rcx, 8 ; skip scan_stack addr

    mov rdx, rbp

.loop_frame:
    cmp qword [rdx + rcx], rdi
    je .found

    add rcx, 8

    cmp rcx, 0
    je .next_frame

    jmp .loop_frame

.next_frame:
    cmp qword [rdx], 0
    je .not_found

    mov rcx, rdx
    sub rcx, qword [rdx]
    add rcx, 16

    mov rdx, qword [rdx]

    jmp .loop_frame

.found:
    mov rax, 1
    ret

.not_found:
    mov rax, 0
    ret