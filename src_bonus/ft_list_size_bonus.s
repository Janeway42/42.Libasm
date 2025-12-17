; int ft_list_size(t_list *begin_list);
; ft_list_size() does returns an integer (size of the list)

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
; For ft_list_size() this means: 
; RDI   -> t_list *begin_list (head pointer)

; RAX   -> return value = the pointer to dest 
; ---------------------------------------------------------------------------------------

%define NODE_DATA 0
%define NODE_NEXT 8
%define NODE_SIZE 16

section .text
global  ft_list_size

ft_list_size:
	xor	    rax, rax		; set RAX  to 0 - default return register in this case used as length counter
							; xor stores in the first operand the result of a bitwise exclusive OR 
							; (0 if equal bits and 1 for different bits)

.loop:
	test    rdi, rdi					; if NULL test will do "0 AND 0 = 0", and set ZF = 1
	jz      .done

	inc     rax							; increment rax
	mov     rdi, [rdi + NODE_NEXT]		; move to the next element of the list
	jmp     .loop

.done:
	ret