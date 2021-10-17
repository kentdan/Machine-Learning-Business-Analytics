# Machine-Learning-Business-Analytics

## This is the first project of the course
It will include the basic of vectors and Julia There are several topics:
1. Inner Product
2. Exception Handling
3. Advanced Exception Handling
4. Magic calculator
5. Reimbursement

## 1. Inner Product
(Inner Product) Define a function called “Inner_Product” that produces the result of the inner product of two vectors.
Example: a = [1, 2, 3], b = [2, 3, 4], your function needs to output 20.
Input: a, b
Output: 20

```Julia
function f(x,y)
           x'*y
       end
Inner_Product = f ;
```
### Solution Description
the dot product formula = x’ * y

## 2. Exception Handling
(Exception Handling) In the lecture, we have learnt that you cannot apply inner product to two vectors with different dimensions. Define a function called “Strict_inner_Product”: if two vectors have the same dimension, output the result of their inner product; otherwise, output a warning and the dimension of two vectors.
Example:
(1) a = [1, 2, 3], b = [2, 3, 4, 5], your function should output “Warning! 3*1 vector can’t
do inner product with a 4*1 vector!”
Input: a, b
Output: Warning! 3*1 vector can’t do inner product with a 4*1 vector!
(2) a = [1, 2, 3], b = [2, 3, 4], your function should print 20. Input: a, b
Output: 20


```Julia
function g(x,y)
    if(size(x) != size(y))
        dx = size(x)
        dy = size(y)
        @warn  " $dx vector can’t do inner product with a $dy vector!"
        return 0
    else
    x'*y
    end
end
Strict_inner_Product = g;
```
### Solution Description
If statement (size z,y is different warn them)
