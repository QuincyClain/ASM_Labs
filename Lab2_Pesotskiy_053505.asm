.model small
.stack 200h

.data

    number dw ?

.code


main:
    mov ax,@data
    mov ds,ax
    call readnumber
    mov ax, bx
    mov bl, 2
    mov dh, 0
    mov bh, 0

division:
    ;if остаток !=0
    cmp ax, bx
    jl printnumber
    mov cx, ax  
    div bl
    cmp ah, 0
    je plus
    mov ax, cx
    inc bl
    jmp division

plus:
    add dh, bl
    cbw
    jmp division

printnumber:
    mov al, dh
    cbw
	cmp ax, 0
	jz printifzero
	jnl printpositive
	mov dl, '-'
	push ax
	mov ah, 02h
	int 21h
	pop ax
    not ax 
	inc ax

printpositive:
	cmp ax, 0
	jz zero
	mov dx, 0
	mov bx, 10
	div bx    
	add dl, 48
	push dx
    call printpositive
	pop dx
	push ax
	mov ah, 02h
	int 21h
	pop ax
    ret

zero:
	ret

printifzero:
	mov dl, 30h
	mov ah, 02h
	int 21h
	ret

exit:
    mov ax, 4c00h
    mov al, 0
    int 21h

readnumber:
	mov bx, 0
    mov ah, 01h
    int 21h
    cmp al, 2dh
	je readnegative
	call workwithstack
	ret
readnegative:
	call readpositive
	not bx 
	inc bx
	ret
readpositive:
    mov ah, 01h
    int 21h
workwithstack:
    cmp al, 0dh
    je endl
    cmp al, 10
    je endl
    sub al, 48
    mov ah, 0
	push ax
	mov ax, 10
    mul bx
    mov bx, ax
	pop ax
    add bx, ax
    call readpositive
endl:
	ret

end     main