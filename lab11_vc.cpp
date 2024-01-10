#include "vectorclass.h" 

//Used as guide: https://www.youtube.com/watch?v=TKjYdLIMTrI&ab_channel=Creel
//Video included in vectorclass.h github page (version2/README)

double dot_double_vc(double* arr1, double* arr2, uint64_t n){

    //Create 2 double-precision vectors, 1 for each array, and an output array
    Vec4d myvector1;
    Vec4d myvector2;
    Vec4d ret_vector(0);
    
    for (uint64_t i = 0; i < n; i += 4){

        //Load 4 double-precision fp into each array
        myvector1.load(arr1 + i);
        myvector2.load(arr2 + i);

        //Multiply the arrays then add the product to the return vector
        myvector2 = myvector1 * myvector2;
        ret_vector += myvector2;
    }

    //Add all the horizontal values of the vector for the dot product
    return horizontal_add(ret_vector);
}



float dot_single_vc(float* arr1, float* arr2, uint64_t n){

    //Create 2 single-precision vectors, 1 for each array, and an output array
    Vec8f myvector1;
    Vec8f myvector2;
    Vec8f ret_vector(0);
    
    for (uint64_t i = 0; i < n; i += 8){

        //Load 8 singles-precision fp into each array
        myvector1.load(arr1 + i);
        myvector2.load(arr2 + i);

        //Multiply the arrays then add the product to the return vector
        myvector2 = myvector1 * myvector2;
        ret_vector += myvector2;
    }

    //Add all the horizontal values of the vector for the dot product
    return horizontal_add(ret_vector);
}



void map_poly_double_vc(double* input, double* output, uint64_t length, double a, double b, double c, double d){

    //Create a vector to hold the 4 double-precision input values
    Vec4d x_vec;

    for (uint64_t i = 0; i < length; i += 4){

        //Load the input values into vector
        x_vec.load(input + i);

        //Broadcast a into a vector and do a*x
        Vec4d a_vec(a);
        a_vec = a_vec * x_vec;

        //Broadcast b and do product + b
        Vec4d b_vec(b);
        a_vec = a_vec + b_vec;

        //Broadcast c and do x * product + c
        Vec4d c_vec(c);
        a_vec = a_vec * x_vec;
        a_vec = a_vec + c_vec;

        //Broadcast d and do x * product + d
        Vec4d d_vec(d);
        a_vec = a_vec * x_vec;
        a_vec = a_vec + d_vec;

        //Write the 4 values to output array
        a_vec.store(output + i);
    }
}



void map_poly_single_vc(float* input, float* output, uint64_t length, float a, float b, float c, float d){
    
    //Create a vector to hold the 8 single-precision input values
    Vec8f x_vec;

    for (uint64_t i = 0; i < length; i += 8){

        //Load the input values into vector
        x_vec.load(input + i);

        //Broadcast a into a vector and do a*x
        Vec8f a_vec(a);
        a_vec = a_vec * x_vec;

        //Broadcast b and do product + b
        Vec8f b_vec(b);
        a_vec = a_vec + b_vec;

        //Broadcast c and do x * product + c
        Vec8f c_vec(c);
        a_vec = a_vec * x_vec;
        a_vec = a_vec + c_vec;

        //Broadcast d and do x * product + d
        Vec8f d_vec(d);
        a_vec = a_vec * x_vec;
        a_vec = a_vec + d_vec;

        //Write the 8 values to output array
        a_vec.store(output + i);
    }
}