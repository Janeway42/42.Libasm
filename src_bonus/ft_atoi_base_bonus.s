; int ft_atoi_base(char *str, char *base);
; ft_atoi_base() returns the integer equivalent of the string 

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
; For ft_atoi_base() this means: 
; RDI   -> str 
; RSI   -> base

; RAX   -> return value = int 
; ---------------------------------------------------------------------------------------

section .text
global  ft_atoi_base

ft_atoi_base:
	test rdi, rdi				; if NULL test will do "0 AND 0 = 0", and set ZF = 1
	jz	.error_input
	
	xor	rcx, rcx            ; set RCX  to 0 - used as length counter
							; xor stores in the first operand the result of a bitwise exclusive OR 
                            ; (0 if equal bits and 1 for different bits)

    xor	r9, r9              ; set R9  to 0 - make sure val storred is not 1 (sign verification)
	
	cmp BYTE [rdi + rcx], 0		; check if first character is '\0'
	jz .error_input
	
.loop_specials:
	cmp edx, 0x0A			; '\n' (newline) = 0x0A
	jz .increment_specials
	cmp edx, 0x09			; '\t' (horizontal tab = 0x09
	jz .increment_specials
	cmp edx, 0x0B			; '\v' (vertical tab) = 0x0B
	jz .increment_specials
	cmp edx, 0x0C			; '\f' (form feed) = 0x0C
	jz .increment_specials
	cmp edx, 0x0D			; '\r' (carriage return) = 0x0D
	jz .increment_specials
    cmp edx, 0x20           ; ' ' (space) = 0x20
	jmp .set_sign
	
.increment_specials:
	inc rcx						; increment string counter 
	cmp BYTE [rdi + rcx], 0		; check for NULL terminator 
	jz .error_input
	jmp .loop_specials
	
.set_sign:
	inc rcx						; increment string counter 
	cmp BYTE [rdi + rcx], 0		; check for NULL terminator '\0'
	jz	.error_input
	cmp BYTE [rdi + rcx], 0x2D	; '-' (hyphen minus) = 0x2D
	jz .set_minus
    cmp BYTE [rdi + rcx], 0x2B  ; '+' (plus) = 0x2B
	jz .set_number
    jmp .set_number_loop
	
.set_minus:
	mov r9, 1					; set - for number 
	jmp .set_number

.set_number:
	inc rcx						; increment string counter 
	cmp BYTE [rdi + rcx], 0		; check for NULL terminator '\0'
    jz .error_input

	xor r8, r8					; set R8 to 0 to use fr the number value
	jmp .set_number_loop
    
.set_number_loop:
	cmp BYTE [rdi + rcx], 0x30	; '0' (number zero) = 0x30
	jb .number_done				; if EAX < 0 (jump if below)
	cmp BYTE [rdi + rcx], 0x39	; '9' (number nine) = 0x39
	ja .number_done				; if EAX > 9 (jump if above)

	imul r8, r8, 10				; multiply by 10
	sub BYTE [rdi + rcx], '0'	; convert char to digit
	add r8, rax					
	
	inc rcx						; increment string counter 
	cmp BYTE [rdi + rcx], 0		; check for NULL terminator '\0'
	jz .number_done
	jmp .set_number_loop
	
.number_done:
	mov rax, r8				; move the value of the integer in RAX (the default return register) 
	cmp r9, 1				; if sign negative 
	jnz .done
	neg rax					; make RAX negative
	jmp .done
	
.error_input:
	xor rax, rax			; set RAX (default return register) to 0
	jmp .done
		
.done:
	ret