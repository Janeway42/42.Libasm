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
extern ft_strlen
extern printf

ft_atoi_base:
	test    rdi, rdi			; if NULL test will do "0 AND 0 = 0", and set ZF = 1
	jz      .error_input
    test    rsi, rsi
    jz      .error_input

    ; save callee saved registers 
    push    rbp
    push    rbx 
    push    r12
    push    r13
    push    r14
    push    r15
    sub     rsp, 8          ; align the stack (6 push * 8 byte) + the function call (which is 8 byte)
                            ; the stack needs to be 16 yte aligned before any call (ABI requirement)

    mov     rbp, rdi            ; save string
    mov     rbx, rsi            ; save base

    cmp     BYTE [rbp + 0], 0     ; check if the first character in string is not '\0'
    jz      .error_input

    cmp     BYTE [rsi + 0], 0     ; check if the first character in base is not '\0'
    jz      .error_input

    ; ------------------------------------------------------ base verification ----------

.verify_base:
    mov     rdi, rbx
    call    ft_strlen
    mov     r15, rax        ; save string length
    cmp     r15, 2          ; must have length greater than 1
    jb      .error_input

    dec     r15

.verify_base_main_loop:     ; i loop
    movzx   r14d, BYTE [rbx + r15]

    cmp     r14b, 0x2B          ; '+' (plus) = 0x2B
    jz      .error_input
    cmp     r14b, 0x2D	        ; '-' (hyphen minus) = 0x2D
    jz      .error_input
    cmp     r14b, 0x20			; ' ' (space) = 0x20
    jz      .error_input
    cmp     r14b, 0x0A			; '\n' (newline) = 0x0A
    jz      .error_input
    cmp     r14b, 0x09			; '\t' (horizontal tab = 0x09
    jz      .error_input
    cmp     r14b, 0x0B			; '\v' (vertical tab) = 0x0B
    jz      .error_input
    cmp     r14b, 0x0C			; '\f' (form feed) = 0x0C
    jz      .error_input
    cmp     r14b, 0x0D			; '\r' (carriage return) = 0x0D
    jz      .error_input

    mov     r13, r15            ; j = i
    dec     r13
    jmp     .verify_base_secondary_loop

.verify_base_secondary_loop:    ; j loop
    cmp     r13, -1
    je      .set_up_for_verify_base_main_loop

    movzx   r12d, BYTE [rbx + r13]
    cmp     r12b, r14b
    je      .error_input

    dec     r13
    jmp     .verify_base_secondary_loop

.set_up_for_verify_base_main_loop:
    dec     r15
    cmp     r15, -1
    je      .set_up_for_atoi
    jmp     .verify_base_main_loop

.set_up_for_atoi:
    xor     r12, r12        ; set R12  to 0 - used as length counter first loop (i loop)
					        ; xor stores in the first operand the result of a bitwise exclusive OR 
                            ; (0 if equal bits and 1 for different bits)
    jmp     .ignore_specials

; ; ------------------------------------------------------ atoi ----------

.ignore_specials:
	cmp     BYTE [rbp + r12], 0x0A			; '\n' (newline) = 0x0A
	jz      .increment_specials
	cmp     BYTE [rbp + r12], 0x09			; '\t' (horizontal tab = 0x09
	jz      .increment_specials
	cmp     BYTE [rbp + r12], 0x0B			; '\v' (vertical tab) = 0x0B
	jz      .increment_specials
	cmp     BYTE [rbp + r12], 0x0C			; '\f' (form feed) = 0x0C
	jz      .increment_specials
	cmp     BYTE [rbp + r12], 0x0D			; '\r' (carriage return) = 0x0D
	jz      .increment_specials
    cmp     BYTE [rbp + r12], 0x20			; ' ' (space) = 0x20
    jz      .increment_specials
	jmp     .set_sign

.increment_specials:
	inc     r12 					        ; increment string counter 
	cmp     BYTE [rbp + r12], 0		        ; check for NULL terminator 
	jz      .error_input
	jmp     .ignore_specials
	
.set_sign:
	cmp     BYTE [rbp + r12], 0		        ; check for NULL terminator '\0'
	jz      .error_input
	cmp     BYTE [rbp + r12], 0x2D	        ; '-' (hyphen minus) = 0x2D
	jz      .set_minus
    cmp     BYTE [rbp + r12], 0x2B          ; '+' (plus) = 0x2B
    jz      .set_plus
    jmp     .set_number

.set_minus:
	mov     r13, 1                          ; set "-" for number 			        
    inc     r12						        ; increment string counter 
	jmp     .set_number

.set_plus:
    inc     r12						        ; increment string counter 
    jmp     .set_number

.set_number:
	cmp     BYTE [rbp + r12], 0		        ; check for NULL terminator '\0'
    jz      .error_input
    cmp     BYTE [rbp + r12], 0x30	        ; '0' (number zero) = 0x30
	jb      .error_input			        ; if EAX < 0 (jump if below)
	cmp     BYTE [rbp + r12], 0x39	        ; '9' (number nine) = 0x39
	ja      .error_input

	xor     r14, r14                        ; set R14  to 0 - to use for the number value
					                        ; xor stores in the first operand the result of a bitwise exclusive OR 
                                            ; (0 if equal bits and 1 for different bits)
    movzx   eax, BYTE [rbp + r12]           ; EAX - lower byte of RAX
    sub     eax, '0'	                    ; convert char to digit - substracts '0' in place in EAX
	add     r14, rax
	inc     r12						        ; increment string counter 
	jmp     .set_number_loop

.set_number_loop:	
    cmp     BYTE [rbp + r12], 0		        ; check for NULL terminator '\0'
    jz      .number_done

	cmp     BYTE [rbp + r12], 0x30	        ; '0' (number zero) = 0x30
	jb      .number_done			        ; if EAX < 0 (jump if below)

	cmp     BYTE [rbp + r12], 0x39	        ; '9' (number nine) = 0x39
	ja      .number_done			        ; if EAX > 9 (jump if above)

	imul    r14, r14, 10			        ; multiply by 10
    movzx   eax, BYTE [rbp + r12]           ; EAX - lower byte of RAX
    sub     eax, '0'	                    ; convert char to digit - substracts '0' in place in EAX
	add     r14, rax
    inc     r12						        ; increment string counter 				
	jmp .set_number_loop
	    
.number_done:
	mov     rax, r14				        ; move the value of the integer in RAX (the default return register) 
	cmp     r13, 1			    	        ; if sign negative 
	jnz     .done
	neg     rax	    				        ; make RAX negative
	jmp     .done


.error_input:
	xor     rax, rax			            ; set RAX (default return register) to 0
    jmp     .done
		
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
