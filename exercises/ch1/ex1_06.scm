// 1.6 this will result in any infinite loop because sqrt-iter will call new-if which will call sqrt-iter...etc. 
//     This is due to applicative order evaluating arguments before the body (ie. sqrt-iter is an argument of new-if)
