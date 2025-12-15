; void ft_list_sort(t_list **begin_list, int (*cmp)());
; ft_list_sort() does not return anything

; setting int (*cmp)() as int ft_strcmp(const char *s1, const char *s2)

; Registers
; As per the System V AMD64 ABI convention: 
; the first six interger/pointer arguments are passed in the following registers:
; RDI -> first argument
; RSI -> second argument
; RDX -> third argument
; RCX -> fourth argument
; R8 -> fifth argument
; R9 ->  sixth argument
; 
; RAX -> designated return register 
; ---------------------------------------------------------------------------------------
; For ft_list_sort() this means: 
; RDI   -> t_list **begin_list = &begin_list -> deferenced pointer = the address of the head pointer 
; RSI   -> int (*cmp)()

; RAX   -> default return value 
; ---------------------------------------------------------------------------------------

%define NODE_DATA 0
%define NODE_NEXT 8
%define NODE_SIZE 16

section .text
global  ft_list_sort

ft_list_sort:
    test    rdi, rdi       ; test if NULL
    je      .error_input
    test    rsi, rsi       ; test if NULL
    je      .error_input

    ; save callee saved registers 
    push    rbp
    push    rbx 
    push    r12
    push    r13
    push    r14
    push    r15
    sub     rsp, 8      ; align the stack (6 push * 8 byte) + the function call (which is 8 byte)
                        ; the stack needs to be 16 yte aligned before any call (ABI requirement)

    mov     rbx, rdi        ; save head 
    mov     r12, rsi        ; save function 

.main_loop:
	xor     r15, r15		; set r15 to 0 - 0 = SORTED, 1 = NOT SORTED

    mov     r13, [rbx]      ; load head node
    test    r13, r13        ; test if NULL
    jz      .done

    mov     r14, [r13 + NODE_NEXT]      ; load next node 
    test    r14, r14                    ; test for NULL
    jz      .done

    mov     rdi, [r13 + NODE_DATA]
    mov     rsi, [r14 + NODE_DATA]
	call    r12         ; (cmp)(rdi, rsi)
    cmp     eax, 0
    jg     .switch      ; jump if greater than 0
    
    jmp .loop


.loop:
    mov     r13, r14
    mov     r14, [r13 + NODE_NEXT]      ; load next node to compare 
    test    r14, r14                    ; if NULL test will do "0 AND 0 = 0", and set ZF = 1
    jz      .sorted

    mov     rdi, [r13 + NODE_DATA]
    mov     rsi, [r14 + NODE_DATA]
	call    r12 			; (cmp)(rdi, rsi)
	cmp     eax, 0
	jg      .switch         ; jump if greater than 0
    jmp     .loop
	
.switch:
	mov     rdi, [r13 + NODE_DATA]	
    mov     rsi, [r14 + NODE_DATA]
	mov     [r13 + NODE_DATA], rsi
	mov     [r14 + NODE_DATA], rdi

	mov     r15, 1
	jmp     .loop
	
.sorted:
	cmp     r15, 0			; if r15 has not neen incremented in this loop the list is sorted
	je      .done            
	jmp     .main_loop			; else go back once more over the list to sort 

.error_input:
    ret

.done:
    ; restore stack
    add     rsp, 8
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    pop     rbp
	ret