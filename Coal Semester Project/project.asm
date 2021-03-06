INCLUDE Irvine32.inc
strLen=26
.data

key BYTE strLen DUP(?),0
istr byte "PLAYFAIR CIPHER FOR COAL PROJECT",0
k_size dword ?
k_sizeb dword ?
Grid byte 25 DUP(0),0
pText byte 250 DUP(0),0
nPText byte 250 DUP(0),0
eText byte 250 DUP(0),0
neText byte 250 DUP(0),0
nPTextSize byte ?
nETextSize byte ?
prompt0 byte "Enter 1 to Encrypt 2 to Dycrypt :",0
prompt1 byte "Enter Your String(max 250 characters) :",0
prompt2 byte "Enter Encrypted String :",0
prompt3 byte "Enter Key:",0
prompt4 byte "The KEY is: ",0
prompt5 byte "The GRID is: ",0
pair1 DWORD 2 DUP(?)
pair2 DWORD 2 DUP(?)
row byte 0
col byte 0
rCo byte 0
cCo byte 0

.code
    main PROC
;		call intro
;		mov edx,0
;		call gotoxy
;		call clrscr
       call begins
        exit
    main ENDP
;----------------------------------------------------------


	begins proc
		call encrypt
		call crlf
		call decrypt
		rets:
			ret
	begins endp
;---------------------------------------------------------------------------------------


	encrypt proc
		call GenerateRandomString
		call GenerateGrid
		call pEntery
		call findT
		ret
	encrypt endp
;----------------------------------------------------------------------------------------


	decrypt proc
		call kEntery
		call GenerateGrid
		call etEntery
		call findeT
	ret
	decrypt endp
;----------------------------------------------------------------------------------------


    GenerateRandomString PROC USES ecx
        mov ecx, lengthOf key
        mov esi, offset key
		mov eax,strlen
		call randomize
		call randomrange
		mov k_size,eax
		mov k_sizeb,eax
		mov ecx,k_size
        L2:
            mov eax, strlen
            call RandomRange
            add eax, 65
			mov edx,ecx
			mov ecx,k_size
			mov edi,offset key
			repne scasb
			jz sameChar
            mov [esi], eax
			inc esi
			mov ecx,edx
			jmp outss
			sameChar:
			mov ecx,edx
			inc ecx
			outss:
        loop L2
		mov edx,offset prompt4
		call writestring
		mov edx,offset key
		call writestring
		call crlf
		mov eax,k_sizeb
		mov k_size,eax
		call crlf
        ret
    GenerateRandomString ENDP
;----------------------------------------------------------------------------------------


	pEntery proc
		mov edx,offset prompt1
		call writeString
		mov edx,offset pText
		mov ecx,lengthof pText
		call readString
		
		mov ecx,lengthof pText
		mov ebx,0
		mov esi,offset pText
		mov edi,offset nPText
		L1:
			lodsb
			cmp al,32
			je outss
			cmp al,'A'
			jl outss
			cmp al,'Z'
			jng skiper
			sub al,32
			skiper:
			cmp al,'Z'
			jg outss
			cmp al,'J'
			jne noJ
				mov al,'I'
			noJ:
				stosb
			inc ebx
			outss:
		loop L1

		mov edx,offset nPText
		mov nPTextSize,bl
		mov eax,ebx
		mov edx,0
		mov ebx,2
		div ebx
		cmp edx,0
		je nNeed
			mov al,'Z'
			inc  nPTextSize
			mov [edi],al
			mov eax,[edi]
		nNeed:
		
			ret	
	pEntery endp
;----------------------------------------------------------------------------------------


	GenerateGrid PROC 
	mov esi, offset key
	mov edi, offset Grid
	mov ebx,0
	mov ecx,k_size
	L1:
	cmp byte ptr [esi],'J'
	je skip
	movzx ebx, byte ptr[esi]
	mov byte ptr [edi],bl
	inc edi
	skip:
	inc esi
	loop L1
	mov ecx,26
	mov ebx,0
	mov bl,65
	L2:
	mov esi,0
	mov edx,0
	mov edx,ecx
	mov ecx,k_size
	L3:
	cmp Grid[esi],bl
	je next_letter
	inc esi
	loop l3
	mov [edi],ebx
	inc edi
	next_letter:
	inc bl
	cmp bl,'J'
	je next_letter
	mov ecx,edx
	loop l2
	mov ecx,25
	mov esi,offset Grid
	mov edi,1
	mov edx,offset prompt5
	call writestring
	call crlf
	print:
		mov eax,[esi]
		call writechar
		cmp edi,5
		jne nope
			call crlf
			mov edi,0
		nope:
		inc esi
		inc edi
	loop print
	call crlf
	ret
	GenerateGrid ENDP
;----------------------------------------------------------------------------------------


	findT proc uses edx
		mov edx,0
		push ebp
		mov ebp,esp
		sub esp , 8
		movzx eax,nPTextSize
		mov ebx,2
		Div ebx
		movzx ecx,al
		
			mov esi,0
		fLoop1:
			mov ebx,ecx
			mov eax,0
			mov edi,0
			movzx eax,npText[esi]
			mov [ebp-4],eax
			inc esi
			movzx eax,npText[esi]
			inc esi
			mov [ebp-8],eax
			mov rCo,0
			fLoop2:
				mov ecx,5
				mov cCo,0
				fLoop3:
					movzx edi,col
					mov eax,[ebp-4]
					cmp al,grid[edi]
					je oLoop
					inc col
					inc cCo
				loop fLoop3
				inc rCo
			jmp fLoop2
			oLoop:
			movzx eax,rCo
			mov pair1[0],eax
			call crlf
			call writeDec
			movzx eax,cCo
			mov pair1[4],eax
			call writeDec


			mov rCo,0
			mov col,0
			fLoop4:
				mov ecx,5
				mov cCo,0
				fLoop5:
					movzx edi,col
					mov eax,[ebp-8]
					cmp al,grid[edi]
					je oLoop2
					inc col
					inc cCo
				loop fLoop5
				inc rCo
			jmp fLoop4
			oLoop2:
			movzx eax,rCo
			mov pair2[0],eax
			call crlf
			call writeDec
			movzx eax,cCo
			mov pair2[4],eax
			call writeDec
			mov ecx,ebx
			dec ecx
			mov col,0
			call change
			mov eax,5
			mov edx,0
			mul pair1[0]
			add eax,pair1[4]
			movzx eax,grid[eax]
			mov eText[esi-2],al
			mov eax,5
			mov edx,0
			mul pair2[0]
			add eax,pair2[4]
			movzx eax,grid[eax]
			mov eText[esi-1],al

			cmp ecx,0
			je endFun
			jmp fLoop1
			endFun:
		mov edx,offset eText
	   call crlf
	   call eSPrint
		add esp,8
		pop ebp
	ret
	findT endp
;----------------------------------------------------------------------------------------


	change proc uses edi esi ebx eax
		mov esi,offset pair1
		mov edi,offset pair2
		mov eax,[esi]
		cmp al,[edi]
		je sRow
		mov eax,[esi+4]
		cmp al,[edi+4]
		je sCol
		mov eax,[esi+4]
		xchg eax,[edi+4]
		mov [esi+4],eax
		jmp rets
		sRow:
			mov eax,[esi+4]
			cmp eax,4
			jne nREdge1
			mov eax,-1
			mov [esi+4],eax
			nREdge1:
			inc eax
			mov [esi+4],eax
			mov eax,[edi+4]
			cmp eax,4
			jne nREdge2
			mov eax,-1
			mov [edi+4],eax
			nREdge2:
			inc eax
			mov [edi+4],eax
			jmp rets
		sCol:
			mov eax,[esi]
			cmp eax,4
			jne nCEdge1
			mov eax,-1
			mov [esi],eax
			nCEdge1:
			inc eax
			mov [esi],eax
			mov eax,[edi]
			cmp al,4
			jne nCEdge2
			mov eax,-1
			mov [edi],eax
			nCEdge2:
			inc eax
			mov [edi],eax
			jmp rets
		rets:

	ret
	change endp
;----------------------------------------------------------------------------------------



	kEntery proc
	mov edx,offset prompt3
	call writestring
	mov ecx,24
	mov edx,offset key
	mov esi,0
	call readstring
	L1:
		movzx eax,key[esi]
		cmp eax,'Z'
		jng skipper
		sub al,32
		mov key[esi],al
		skipper:
		cmp eax,0
		je outss
		inc esi
	loop L1
	outss:
	mov k_size,esi
	ret
	kEntery endp
;----------------------------------------------------------------------------------------


	eTEntery proc
		
		mov ebx,0
		mov esi,offset eText
		mov edi,offset neText
		L1:
			lodsb
			cmp al,32
			je outss
			cmp al,'A'
			jl outss
			cmp al,'Z'
			jng skipper
			sub al,32
			skipper:
			cmp al,'Z'
			jg outss
			cmp al,0
			je ls
			stosb
			inc ebx
			outss:
		loop L1
		ls:
		mov edx,offset nPText
		mov nETextSize,bl
			ret
	eTEntery endp
;----------------------------------------------------------------------------------------


	findET proc
	push ebp
	mov edx,0
		mov ebp,esp
		sub esp , 8
		movzx eax,nETextSize
		mov ebx,2
		Div ebx
		movzx ecx,al
		
			mov esi,0
		fLoop1:
			mov ebx,ecx
			mov eax,0
			mov edi,0
			movzx eax,neText[esi]
			mov [ebp-4],eax
			inc esi
			movzx eax,neText[esi]
			inc esi
			mov [ebp-8],eax
			mov rCo,0
			fLoop2:
				mov ecx,5
				mov cCo,0
				fLoop3:
					movzx edi,col
					mov eax,[ebp-4]
					cmp al,grid[edi]
					je oLoop
					inc col
					inc cCo
				loop fLoop3
				inc rCo
			jmp fLoop2
			oLoop:
			movzx eax,rCo
			mov pair1[0],eax
			call crlf
			call writeDec
			movzx eax,cCo
			mov pair1[4],eax
			call writeDec


			mov rCo,0
			mov col,0
			fLoop4:
				mov ecx,5
				mov cCo,0
				fLoop5:
					movzx edi,col
					mov eax,[ebp-8]
					cmp al,grid[edi]
					je oLoop2
					inc col
					inc cCo
				loop fLoop5
				inc rCo
			jmp fLoop4
			oLoop2:
			movzx eax,rCo
			mov pair2[0],eax
			call crlf
			call writeDec
			movzx eax,cCo
			mov pair2[4],eax
			call writeDec
			mov ecx,ebx
			dec ecx
			mov col,0
			call unchange
			mov eax,5
			mov edx,0
			mul pair1[0]
			add eax,pair1[4]
			movzx eax,grid[eax]
			mov npText[esi-2],al
			mov eax,5
			mov edx,0
			mul pair2[0]
			add eax,pair2[4]
			movzx eax,grid[eax]
			mov npText[esi-1],al

			cmp ecx,0
			je endFun
			jmp fLoop1
			endFun:
		call crlf
	   call pSPrint
		add esp,8
		pop ebp
	ret
	findET endp
;----------------------------------------------------------------------------------------
	
	
	unchange proc  uses edi esi ebx eax
		mov esi,offset pair1
		mov edi,offset pair2
		mov eax,[esi]
		cmp al,[edi]
		je sRow
		mov eax,[esi+4]
		cmp al,[edi+4]
		je sCol
		mov eax,[esi+4]
		xchg eax,[edi+4]
		mov [esi+4],eax
		jmp rets
		sRow:
			mov eax,[esi+4]
			cmp eax,0
			jne nREdge1
			mov eax,5
			mov [esi+4],eax
			nREdge1:
			dec eax
			mov [esi+4],eax
			mov eax,[edi+4]
			cmp eax,0
			jne nREdge2
			mov eax,5
			mov [edi+4],eax
			nREdge2:
			dec eax
			mov [edi+4],eax
			jmp rets
		sCol:
			mov eax,[esi]
			cmp eax,0
			jne nCEdge1
			mov eax,5
			mov [esi],eax
			nCEdge1:
			dec eax
			mov [esi],eax
			mov eax,[edi]
			cmp al,0
			jne nCEdge2
			mov eax,5
			mov [edi],eax
			nCEdge2:
			dec eax
			mov [edi],eax
			jmp rets
		rets:
		ret
	unchange endp

	ESPrint proc
	mov esi,0
	mov edi,offset pText
	movzx ecx,nPTextSize
	mov ebx,0
	L1:
	mov bl,byte ptr[edi]
	cmp ebx,32
	jne skip
	mov eax,32
	call writeChar
	skip:
	movzx eax,eText[esi]
	call writeChar
	inc esi
	inc edi
	loop L1
	ret
	eSPrint endp


	pSPrint proc
	mov esi,0
	mov edi,offset eText
	movzx ecx,neTextSize
	mov ebx,0
	L1:
	mov bl,byte ptr[edi]
	cmp ebx,32
	jne skip
	mov eax,32
	call writeChar
	skip:
	movzx eax,nPText[esi]
	call writeChar
	inc esi
	inc edi
	loop L1
	ret
	pSPrint endp

	intro proc
	mov edx,0
mov ecx ,120
L1:
mov eax ,'/'
call gotoxy
call writeChar
mov eax, 15
call delay
inc dl
loop L1
mov ecx,25
dec dl
inc dh
L2:
mov eax ,'/'
call gotoxy
call writeChar
mov eax, 25
call delay
inc dh

loop L2
dec dh
dec dl
mov ecx,120
L3:
mov eax ,'/'
call gotoxy
call writeChar
mov eax, 15
call delay
dec dl
loop L3
dec dh
mov dl,0
mov ecx,25
L4:
mov eax ,'/'
call gotoxy
call writeChar
mov eax, 25
call delay
dec dh
loop L4
mov dh,12
mov dl,40
call gotoxy
mov edx,offset istr
call writestring
mov ecx,4
L5:

loop L5
mov eax,1500
call delay
mov eax,0

	ret
	intro endp


END main
