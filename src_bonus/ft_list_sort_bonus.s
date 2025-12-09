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
	mov r8, rdi			; save list 
	mov r9, rsi			; save function 

.main_loop:
	xor rcx, rcx		; set RCX  to 0 - use as counter to determine if list is sorted

	mov rdi, [r8]		; load head 
	test rdi, rdi		; if NULL test will do "0 AND 0 = 0", and set ZF = 1
	jz .done

	mov rsi, [rdi + NODE_NEXT]		; load next node 
	test rsi, rsi					; if NULL test will do "0 AND 0 = 0", and set ZF = 1
	jz .done
	
	call r9 			; (cmp)(rdi, rsi)
	test rax, rax		; if filter sign SF = 1 the result is negative 
	jns .switch
	
.loop:
	mov rdi, rsi
	mov rsi, [rsi + NODE_NEXT] 		; load next node to compare 
	test rsi, rsi					; if NULL test will do "0 AND 0 = 0", and set ZF = 1
	jz .sorted
	call r9 						; (cmp)(rdi, rsi)
	test rax, rax					; SF = 1
	jns .switch
    jmp .loop
	
.switch:
	mov rdx, [rdi + NODE_DATA]		; RDX = temp storage for the switch 
    mov rax, [rsi, NODE_DATA]		; temp storage to get the value at the memory location 
	mov [rdi + NODE_DATA], rax
	mov [rsi + NODE_DATA], rdx
	inc rcx 
	jmp .loop
	
.sorted:
	test rcx, rcx			; if RCX has not neen incremented in this loop the list is sorted
	jz .done            
	jmp .main_loop			; else go back once more over the list to sort 

.done:
	ret