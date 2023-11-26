# macro:
#	Razrabotannaya programma dolzhna chitat' obrabatyvaemyj tekst iz fajla i
#	zagruzhat' poluchennye rezul'taty takzhe v fajl. Vvod imen vhodnogo i
#	vyhodnogo fajlov dolzhen osushchestvlyat'sya s ispol'zovaniem konsoli.
#	Analogichnym obrazom osushchestvlyaet vvod ostal'nyh parametrov,
#	neobhodimyh dlya vypolneniya programmy.
# arguments:
#	IF - input file name string address (register, input)
#	OF - output file name string address (register, input)
#	WN - words number (register, input)
#	W1 - word addresses array address (register, input)
#	W2 - word counters array address (register, input)
# return:
#	a0 - function result (register)
#	     0 - ok
#	     non-0 - file open/read
.macro	idz3	(%IF, %OF, %WN, %W1, %W2)
	addi	sp, sp, -20		# obtain stack for arguments
	sw	%IF, +0(sp)		# store input file name string address
	sw	%OF, +4(sp)		# store output file name string address
	sw	%WN, +8(sp)		# store words number value
	sw	%W1, +12(sp)		# store word addresses array address
	sw	%W2, +16(sp)		# store word counters array address
	jal	idz3_func		# call function
	addi	sp, sp, 20		# free stack
.end_macro


# macro:
#	27. Razrabotat' programmu, kotoraya opredelyaet chastotu vstrechaemosti
#	(skol'ko raz vstretilos' v tekste) pyati klyuchevyh slov yazyka
#	programmirovaniya C, v proizvol'noj ASCII–stroke. Klyuchevye slova ne
#	dolzhny yavlyat'sya chast'yu identifikatorov. Pyat' iskomyh klyuchevyh
#	slov vybrat' po svoemu usmotreniyu. Testirovat' mozhno na fajlah programm.
#	Vyvod rezul'tatov organizovat' v fajl (ispol'zuya sootvetstvuyushchie
#	preobrazovaniya chisel v stroki).
# arguments:
#	WA - work area address (register, input)
#	BA - buffer address (register, input)
#	DL - data length (register, input)
#	WN - words number (register, input)
#	W1 - word addresses array address (register, input)
#	W2 - word counters array address (register, input)
.macro	var27	(%WA, %BA, %DL, %WN, %W1, %W2)
	addi	sp, sp, -24		# obtain stack for arguments
	sw	%WA, +0(sp)		# store work area address
	sw	%BA, +4(sp)		# store buffer address
	sw	%DL, +8(sp)		# store data length value
	sw	%WN, +12(sp)		# store words number value
	sw	%W1, +16(sp)		# store word addresses array address
	sw	%W2, +20(sp)		# store word counters array address
	jal	var27_func		# call function
	addi	sp, sp, 24		# free stack
.end_macro


# macro:
#	Print file context to console
# arguments:
#	IF - input file name string address (register, input)
.macro	cat	(%IF)
	addi	sp, sp, -4		# obtain stack for arguments
	sw	%IF, +0(sp)		# store input file name string address
	jal	cat_func		# call function
	addi	sp, sp, 4		# free stack
.end_macro


# macro:
#	Input text
# arguments:
#	S - input buffer size value (register, input)
#	B - input buffer address (register, input)
.macro	inputT	(%S, %B)
	addi	sp, sp, -8		# obtain stack for arguments
	sw	%S, +0(sp)		# store S
	sw	%B, +4(sp)		# store B
	jal	inputT_func		# call function
	addi	sp, sp, 8		# free stack
.end_macro


# macro:
#	Unsigned integer to string
# arguments:
#	U - unsigned integer value (register, input)
#	S - result string address (register, input)
.macro	utoa	(%U, %S)
	addi	sp, sp, -8		# obtain stack for arguments
	sw	%U, +0(sp)		# store U
	sw	%S, +4(sp)		# store S
	jal	utoa_func		# call function
	addi	sp, sp, 8		# free stack
.end_macro


# macro:
#	Open file
# arguments:
#	N - file name string address (register, input)
#	F - file open flags (register, input)
# return:
#	a0 - file descriptor
.macro	fopen	(%N, %F)
	addi	sp, sp, -8		# obtain stack for arguments
	sw	%N, +0(sp)		# store N
	sw	%F, +4(sp)		# store F
	jal	fopen_func		# call function
	addi	sp, sp, 8		# free stack
.end_macro


# macro:
#	Close file
# arguments:
#	H - file descriptor value (register, input)
.macro	fclose	(%H)
	addi	sp, sp, -4		# obtain stack for arguments
	sw	%H, +0(sp)		# store H
	jal	fclose_func		# call function
	addi	sp, sp, 4		# free stack
.end_macro


# macro:
#	Read from file
# arguments:
#	H - file descriptor value (register, input)
#	B - buffer address (register, input)
#	S - buffer size value (register, input)
# return:
#	a0 - the length read or -1 if error
.macro	fread	(%H, %B, %S)
	addi	sp, sp, -12		# obtain stack for arguments
	sw	%H, +0(sp)		# store H
	sw	%B, +4(sp)		# store H
	sw	%S, +8(sp)		# store H
	jal	fread_func		# call function
	addi	sp, sp, 12		# free stack
.end_macro


# macro:
#	Write to a filedescriptor from a buffer
# arguments:
#	H - file descriptor value (register, input)
#	B - buffer address (register, input)
#	S - buffer size value (register, input)
# return:
#	a0 - the length read or -1 if error
.macro	fwrite	(%H, %B, %S)
	addi	sp, sp, -12		# obtain stack for arguments
	sw	%H, +0(sp)		# store H
	sw	%B, +4(sp)		# store H
	sw	%S, +8(sp)		# store H
	jal	fwrite_func		# call function
	addi	sp, sp, 12		# free stack
.end_macro


# macro:
#	Allocate array memory
# arguments:
#	N - array items number (register, input)
#	S - array item size (register, input)
# return:
#	register (a0) - allocated address
.macro	alloc_A	(%N,%S)
	addi	sp, sp, -8		# obtain stack for arguments
	sw	%N, +0(sp)		# store array items number
	sw	%S, +4(sp)		# store array item size
	jal	calloc_func		# call function
	addi	sp, sp, 8		# free stack
.end_macro


# macro:
#	Print array
# arguments:
#	T - text (register, input)
#	N - array items number (register, input)
#	A - array address (register, output)
.macro	print_A	(%T, %N, %A)
	addi	sp, sp, -12		# obtain stack for arguments
	sw	%T, +0(sp)		# store T - text
	sw	%N, +4(sp)		# store N - array items number
	sw	%A, +8(sp)		# store A - array address
	jal	print_A_func		# call function
	addi	sp, sp, 12		# free stack
.end_macro


# macro:
#	Ask User to Repeat Calculation
# return:
#	a0 - register
.macro	ask_ANF
	jal	ask_ANF_func		# call function
.end_macro


# macro:
#	Print Integer to console
.macro	coutI
	li	a7, 1
	ecall
.end_macro


# macro:
#	Print Hex to console
.macro	coutX
	li	a7, 34
	ecall
.end_macro


# macro:
#	Print Text to console
# arguments:
#	text - label
.macro	coutT	(%text)
	la	a0, %text
	li	a7, 4
	ecall
.end_macro


# macro:
#	Print Text to console
.macro	coutT0
	li	a7, 4
	ecall
.end_macro


# macro:
#	Print Text to console
# arguments:
#	text - register
.macro	coutTr	(%text)
	mv	a0, %text
	li	a7, 4
	ecall
.end_macro


# macro:
#	Read char from console
.macro	cinC
	li	a7, 12
	ecall
.end_macro


# macro:
#	Reads a string from the console
# arguments:
#	size - register
#	text - register
.macro	cinT	(%size, %text)
	mv	a1, %size
	mv	a0, %text
	li	a7, 8
	ecall
.end_macro


# macro:
#	Service to display a message to a user
#	and request a string input
# arguments:
#	mssg - register - message to display
#	size - register - input buffer size
#	text - register - input buffer address
.macro	DinT	(%mssg, %size, %text)
	mv	a0, %mssg
	mv	a1, %text
	mv	a2, %size
	li	a7, 54
	ecall
.end_macro


# macro:
#	Service to display a message to user (ConfirmDialog)
# arguments:
#	mssg - register - message to display
.macro	DcmT	(%mssg)
	mv	a0, %mssg
	li	a7, 50
	ecall
.end_macro


# macro:
#	Service to display a message to user (MessageDialog)
# arguments:
#	mssg - register - message to display
.macro	DmdT	(%mssg, %flag)
	li	a7, 55			# Service to display a message to user
	la	a0, %mssg		# load error message address
	li	a1, %flag		# message flag
	ecall
.end_macro


# macro:
#	Finish program with code 0 
.macro	done
	li	a7, 10
	ecall
.end_macro
