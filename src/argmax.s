.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    # check if a1 >= 1
    bge x0, a1, exception
    # Prologue
    addi sp, sp, -4
    sw s0, 0(sp)

loop_start:
    addi t0, x0, 0 # i
    addi s0, x0, 0 # return value

loop_continue:
    beq t0, a1, loop_end    # if t0 == a1 then loop_end
    slli t1, t0, 2          # t1 = t0 * 4
    add t2, t1, a0          # t2 = t1 + a0
    lw t3, 0(t2)            # t3 is curVlue
    slli t1, s0, 2          # t1 = s0 * 4
    add t2, t1, a0          # t2 = t1 + a0
    lw t4, 0(t2)            # t4 is curMax
    bge t4, t3, else        # if t4 >= t3 then do nothing
    add s0, x0, t0
else:
    addi t0, t0, 1
    jal x0 loop_continue
    
loop_end:
    add a0, x0, s0

    # Epilogue
    lw s0, 0(sp)
    addi sp, sp, 4
    
	ret

exception:
    li a1, 77
    j exit2
