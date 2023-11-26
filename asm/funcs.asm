.global	killnl_func
.global	strlen_func
.global	strcmp_func
.global	calloc_func
.global	iscsymb_func


# function:
#	Kill new-line character (fast call)
# arguments:
#	register (a1) - (i) - null-terminated string
.text
killnl_func:
	li	t0, '\n'			# load new-line character
killnl_do:
	lbu	t1, (a1)			# load character from string
	beq	t1, zero, killnl_end	# branch if character is zero (end of strings)
	beq	t1, t0, killnl_kl		# branch if character is new-line
	addi	a1, a1, 1		# goto next character of string 1
	j	killnl_do		# next iteration
killnl_kl:
	sb	zero, (a1)		# kill new-line character
killnl_end:
	ret				# return


# function:
#	Calculate string length (fast call)
# arguments:
#	register (a1) - (i) - null-terminated string
# return:
#	register (a0) - string length
.text
strlen_func:
	li	a0, 0			# initialize return value
strlen_do:
	lbu	t1, (a1)			# load character from string
	beq	t1, zero, strlen_end	# branch if character is zero (end of strings)
	addi	a0, a0, 1		# increment string length counter
	addi	a1, a1, 1		# goto next character of string
	j	strlen_do		# next iteration
strlen_end:
	ret				# return


# function:
#	Compare string (fast call)
# arguments:
#	register (a1) - (i) - null-terminated string 1
#	register (a2) - (i) - null-terminated string 2
# return:
#	register (a0) - result code
#		0 - strings is equal
#		other - strings is not equal
.text
strcmp_func:
strcmp_do:
	lbu	t1, (a1)			# load character from string 1
	lbu	t2, (a2)			# load character from string 2
	sub	a0, t1, t2		# compare loaded characters
	bne	a0, zero, strcmp_end	# branch if characters is not equal
	beq	t1, zero, strcmp_end	# branch if character 1 is zero (end of both strings)
	addi	a1, a1, 1		# goto next character of string 1
	addi	a2, a2, 1		# goto next character of string 2
	j	strcmp_do		# next iteration
strcmp_end:
	ret				# return


# function:
#	Allocate memory block & initialize it zeros
# arguments:
#	stack (+00) - (i) - items number
#	stack (+04) - (i) - item size
# return:
#	register (a0) - allocated address
.text
calloc_func:
	lw	a0, +0(sp)		# load items number
	lw	t0, +4(sp)		# load item size
	mul	a0, a0, t0		# calculate memory block size
	li	a7, 9			# allocate heap memory
	ecall				# environment call
	mv	a7, a0			# load allocated address
calloc_do:
	beq	zero, t0, calloc_end	# branch if end of counter
	sb	zero, (a7)		# initialize current byte
	addi	a7, a7, 1		# goto next byte
	addi	t0, t0, -1		# decrement counter
	j	calloc_do		# goto next character
calloc_end:
	ret				# return


# function:
#	Check if the given character is an C-valid symbol (fast call)
# arguments:
#	register (a7) - (i) - given character
# return:
#	register (a0) - result code
#		1 - valid C symbol
#		0 - invalid C symbol
.text
iscsymb_func:
	li	a0, 0			# initialize negative return value
	la	t0, iscsymb_data		# load test string address
iscsymb_do:
	lbu	t1, (t0)			# load current character from string
	beqz	t1, iscsymb_end		# branch if end of string
	addi	t0, t0, 1		# goto next character in test string
	bne	t1, a7, iscsymb_do	# test current and given character
	li	a0, 1			# set positive return value
iscsymb_end:
	ret				# return


# local data:
#	iscsymb_data - valid C-symbol test string
.data
iscsymb_data:	.asciz	"0123456789_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
