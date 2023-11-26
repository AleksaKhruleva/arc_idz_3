.global	inputT_func
.include "lib_macros.asm"


# function:
#	Input text
# save area:
.eqv	sa_ra	+0(sp)	# stack (+00) - register ra (return address)
.eqv	sa_s0	+4(sp)	# stack (+04) - register s0
.eqv	sa_size	8
# arguments area:
.eqv	arg1	+0(s0)	# stack (+00) - (i) - input buffer size value
.eqv	arg2	+4(s0)	# stack (+04) - (i) - input buffer address
# return:
#	a0 - function result (register) - input string length
# register usage:
#	s0 - on-call stack position (arguments area)
.text
inputT_func:
	# save registers
	addi	sp, sp, -sa_size		# obtain stack for save area
	sw	ra, sa_ra		# save ra register
	sw	s0, sa_s0		# save s0 register
	addi	s0, sp, sa_size		# set on-call stack position (arguments area)
	# function body
	lw	t1, arg1			# load maximum number of characters to read value
	lw	t2, arg2			# load input buffer address
	cinT	(t1, t2)
	lw	t1, arg2			# load input buffer address
	li	t0, '\n'			# load new-line character

_l0:	lbu	t2, (t1)			# load current character
	addi	t1, t1, 1		# goto next character
	bne	t0, t2, _l0		# branch if current character is not new-line
	addi	t1, t1, -1		# goto actual new-line character position
	sb	zero, (t1)		# replace new-line to '\0'
	lw	a1, arg2			# load input buffer address
	jal	strlen_func		# calculate inputed string length

	# end of function
_end:	lw	ra, sa_ra		# load ra register
	lw	s0, sa_s0		# load s0 register
	addi	sp, sp, sa_size		# free stack for save area
	ret				# return
