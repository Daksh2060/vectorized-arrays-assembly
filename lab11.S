    .section .note.GNU-stack,"" 
    .global dot_double, map_poly_double, dot_single, map_poly_single, dot_double_vec, dot_single_vec, map_poly_double_vec, map_poly_single_vec
    .text



dot_double:

    mov $0, %r10             #set index counter to 0       
    pxor %xmm0, %xmm0        #set return register to 0           

dot_double_loop:    

    cmp %r10, %rdx           #check to see if array end is reached         
    je end_dot_double                            

    movq (%rdi), %xmm1       #move values from arrays into registers             
    movq (%rsi), %xmm2                     

    mulsd %xmm1, %xmm2       #multiply the two values and add them to the total              
    addsd %xmm2, %xmm0                   

    add $8, %rdi             #increment arrays to next index and increment counter             
    add $8, %rsi
    inc %r10                            

    jmp dot_double_loop                        

end_dot_double:

    ret





dot_single:

    mov $0, %r10              
    pxor %xmm0, %xmm0                     

dot_single_loop:    

    cmp %r10, %rdx                     
    je end_dot_single                            

    movd (%rdi), %xmm1      #changed movq to movd               
    movd (%rsi), %xmm2                     

    mulss %xmm1, %xmm2      #changed mulsd to mulss                     
    addss %xmm2, %xmm0      #changed addsd to addss            

    add $4, %rdi            #increment array pointers by 4 bytes instead of 8            
    add $4, %rsi
    inc %r10                            

    jmp dot_single_loop                        

end_dot_single:

    ret





dot_double_vec:

    mov $0, %r10                            #set index accumulator
    vxorpd %ymm0, %ymm0, %ymm0              #zero out return vector

dot_double_vec_loop:    

    cmp %r10, %rdx                          #check if accumulator has reached end of array
    je end_dot_double_vec     

    vmovupd (%rdi, %r10, 8), %ymm1          #load 4 double fp into vectors each 8 bytes
    vmovupd (%rsi, %r10, 8), %ymm2                  

    vmulpd %ymm1, %ymm2, %ymm3              #multiply arrays and add them to return vector      
    vaddpd %ymm3, %ymm0, %ymm0                   

    add $4, %r10                            #increment index by 4 for 4 fp    

    jmp dot_double_vec_loop                 #loop       

end_dot_double_vec:                         

    vextractf128 $0x1, %ymm0, %xmm1         #horizontal add taken from lecture slides
    vaddpd %xmm1, %xmm0, %xmm0
    vshufpd $0b01, %xmm0, %xmm0, %xmm1
    vaddsd %xmm1, %xmm0, %xmm0
    ret





dot_single_vec:

    mov $0, %r10                            #same as doubles with slight adjustments
    vxorps %xmm0, %xmm0, %xmm0              #chnages vxorpd to vxords to zero out singles vector

dot_single_loop_vec:

    cmp %r10, %rdx                  
    je end_dot_single_vec     

    vmovups (%rdi, %r10, 4), %xmm1          #move 2 single-precision fp each 4 bytes to vectors
    vmovups (%rsi, %r10, 4), %xmm2          #changed vmovupd to vmovupd            

    vmulps %xmm1, %xmm2, %xmm3              #changed vmulpd to vmulps for singles 
    vaddps %xmm3, %xmm0, %xmm0                   

    add $2, %r10                            #incrmenet index

    jmp dot_single_loop_vec   

end_dot_single_vec:
 
    vextractf128 $0x1, %ymm0, %xmm1         #Same horizontal add, but doubles changed to singles
    vaddps %xmm1, %xmm0, %xmm0
    vshufps $0b01, %xmm0, %xmm0, %xmm1
    vaddss %xmm1, %xmm0, %xmm0
    ret





map_poly_double:

    mov $0, %r9                 #set index counter to 0

poly_loop_double:

    cmp %r9, %rdx               #check if end of array reached
    je end_poly_double

    movq (%rdi), %xmm8          #move double value of x from array to fp register

    mulsd %xmm0, %xmm8          #multiply x by a
    addsd %xmm1, %xmm8          #add b to product

    mulsd (%rdi), %xmm8         #multiply total by x
    addsd %xmm2, %xmm8          #add c to product

    mulsd (%rdi), %xmm8         #mutiply total by x
    addsd %xmm3, %xmm8          #add d to product

    movq %xmm8, (%rsi)          #move total result into output array

    add $8, %rdi                #incrment both arrays and index counter
    add $8, %rsi
    add $1, %r9

    jmp poly_loop_double

end_poly_double:

    ret





map_poly_single:

    mov $0, %r9 

poly_loop_single:

    cmp %r9, %rdx
    je end_poly_single

    movd (%rdi), %xmm8          #changed all movq to movd

    mulss %xmm0, %xmm8          #changed all mulsd to mulss
    addss %xmm1, %xmm8          #changed all addsd to addss

    mulss (%rdi), %xmm8
    addss %xmm2, %xmm8

    mulss (%rdi), %xmm8
    addss %xmm3, %xmm8
    
    movd %xmm8, (%rsi)

    add $4, %rdi                #add 4 bytes to array pointers instead of 8 to increment
    add $4, %rsi
    add $1, %r9

    jmp poly_loop_single

end_poly_single:

    ret





map_poly_double_vec:

    mov $0, %r10                            #set accumulator to 0 for checking against array
    vxorpd %ymm4, %ymm4, %ymm4              #zero out storage vector

poly_loop_double_vec:

    cmp %r10, %rdx                          #check if end of array reached
    je end_poly_double_vec

    vmovupd (%rdi, %r10, 8), %ymm5          #load input values of x into vector
    vbroadcastsd %xmm0, %ymm6               #broadcast a into vector

    vmulpd %ymm6, %ymm5, %ymm4              #multiply a by x

    vbroadcastsd %xmm1, %ymm6               #broadcast b into vector
    vaddpd %ymm6, %ymm4, %ymm4              #add b to product of above
    
    vmulpd %ymm5, %ymm4, %ymm4              #multiply sum of above by x

    vbroadcastsd %xmm2, %ymm6               #broadcast c
    vaddpd %ymm6, %ymm4, %ymm4              #add c to product of above

    vmulpd %ymm5, %ymm4, %ymm4              #multiply sum of above by x

    vbroadcastsd %xmm3, %ymm6               #broadcast d
    vaddpd %ymm6, %ymm4, %ymm4              #add d to product of above

    vextractf128 $0x1, %ymm4, %xmm8         #extract upper 128 bits and store
    vextractf128 $0x0, %ymm4, %xmm9         #extract lower 128 bits and store

    vmovapd %xmm9, (%rsi)                   #move first 2 numbers into output array

    add $16, %rsi                           #increment by 16 bits to move 2 spaces

    vmovapd %xmm8, (%rsi)                   #move next 2 numbers into output array

    add $4, %r10                            #increment index counter by 4
    add $16, %rsi                           #increment by 16 bits to move another 2 spaces

    jmp poly_loop_double_vec

end_poly_double_vec:

    ret





map_poly_single_vec:

    mov $0, %r10                            #same as doubles implementation above, with adjustments
    vxorps %xmm4, %xmm4, %xmm4

poly_loop_single_vec:


    cmp %r10, %rdx             
    je end_poly_double_vec

    vmovups (%rdi, %r10, 4), %xmm5          #Changed vmovapd to vmovaps to move singles
    vbroadcastss %xmm0, %xmm6               #broacasts single instead of double fp to vector

    vmulps %xmm6, %xmm5, %xmm4              #same as doubles from here on, with all double instructions changed to singles

    vbroadcastss %xmm1, %xmm6  
    vaddps %xmm6, %xmm4, %xmm4
    
    vmulps %xmm5, %xmm4, %xmm4     

    vbroadcastss %xmm2, %xmm6  
    vaddps %xmm6, %xmm4, %xmm4

    vmulps %xmm5, %xmm4, %xmm4 

    vbroadcastss %xmm3, %xmm6 
    vaddps %xmm6, %xmm4, %xmm4              #no need to extract as all 4 singles fit into 128 bits

    vmovaps %xmm4, (%rsi)                   #move singles into output array

    add $4, %r10                            #increment accumulator for array
    add $16, %rsi                           #add 16 bits to index to move 4 spaces

    jmp poly_loop_single_vec

end_poly_single_vec:

    ret


