# int i = 0;
# int max = 0l
# for (i = 0; i < 10; i++)
//    if (max < A[i]) 
#         max = A[i]

# i <- x6
# A[i] <- x9
# max <- x8

        add x6,x0,x0
        addi x8,x0,0

LOOP:   slti x7,x6,40
        beq x7,x0,END_LOOP
        lw x9,0(x6)

IF:     slt x1,x8,x9
	    beq x1,x0, END_IF
        add x8,x0,x9

END_IF: addi x6,x6,4
	    j LOOP

END_LOOP:
