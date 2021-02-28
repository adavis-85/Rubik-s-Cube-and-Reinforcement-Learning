##Packages needed to perform operations

 using Pkg
 Pkg.add("Statistics
 using Statistics
 Pkg.add("RandomNumbers")
 using RandomNumbers


 ##An unscrambled cube is built using six 3 by 3 matrices and putting them together side by side consecutively
 front=[1 1 1;1 1 1;1 1 1]
 back=[2 2 2;2 2 2;2 2 2]
 left=[3 3 3;3 3 3;3 3 3]
 right=[4 4 4;4 4 4;4 4 4]
 top=[5 5 5;5 5 5;5 5 5]
 bottom=[6 6 6;6 6 6;6 6 6]

 cube=hcat(front,back,left,right,top,bottom)
 
 1  1  1  2  2  2  3  3  3  4  4  4  5  5  5  6  6  6
 1  1  1  2  2  2  3  3  3  4  4  4  5  5  5  6  6  6
 1  1  1  2  2  2  3  3  3  4  4  4  5  5  5  6  6  6

 ##The movement functions for the cube.  As the cube is in matrix form the possible moves are on each group of 
 ##3 by 3 matrices of the cube 

 ##This function performs a rotation on the right side of the cube.  The right side of the cube is 
 ##rotated 90 degrees clockwise as the cube is held in front of you.
 function r(mates)

     ##don't actually change this since you will be passing the scramble. not
     ##changing the real matrix from the beginning.  
     mate=copy(mates)

     ##front-top-back-bottom rotation for right side.  
     ##for prime reverse the order of these equations.
     mate[:,3]=mates[:,18]
     mate[:,18]=mates[:,6]
     mate[:,6]=mates[:,15]
     mate[:,15]=mates[:,3]

     ##now to update the right side
     mate[:,10:12]=rotr90(mates[:,10:12])

     return mate
 end

 ##This move the right side of the cube counter clockwise.  This function reverses the direction of moving
 ##the right side of the cube 90 degrees clockwise.
 function rprime(mat)

     mate=copy(mat)

     mate[:,3]=mat[:,15]
     mate[:,15]=mat[:,6]
     mate[:,18]=mat[:,3]
     mate[:,6]=mat[:,18]

     ##rotate left
     mate[:,10:12]=rotl90(mat[:,10:12])

     return mate
 end

 ##This function moves the left side of the cube in a clockwise direction with the cube facing you.  
 function l(mat)

     mate=copy(mat)

     mate[:,1]=mat[:,16]
     mate[:,16]=mat[:,4]
     mate[:,4]=mat[:,13]
     mate[:,13]=mat[:,1]

     ##rotate left
     mate[:,7:9]=rotl90(mat[:,7:9])

     return mate
 end

 ##This performs the opposite action of the "l" function
 function lprime(mat)

     mate=copy(mat)

     mate[:,16]=mat[:,1]
     mate[:,4]=mat[:,16]
     mate[:,13]=mat[:,4]
     mate[:,1]=mat[:,13]

     ##rotate left
     mate[:,7:9]=rotr90(mat[:,7:9])

     return mate
 end

 ##This function moves the top of the cube 90 degrees clockwise.
 function u(mat)

     mate=copy(mat)

     mate[1,:1:12]=[mat[1,:10:12];mat[1,:7:9];mat[1,:1:6]]
     mate[:,13:15]=rotr90(mat[:,13:15])

     return mate
 end

 ##This function peforms the opposide of the "u" function.  It moves the top of the cube 90 degrees counter-
 ##clockwise
 function uprime(mat)

     mate=copy(mat)

     mate[1,:1:12]=[mat[1,:7:12];mat[1,:4:6];mat[1,:1:3]]
     mate[:,13:15]=rotl90(mat[:,13:15])

     return mate
 end

 ##This function moves the bottom of the cube 90 degrees clockwise
 function dprime(mat)

     mate=copy(mat)

     mate[3,:1:12]=[mat[3,:10:12];mat[3,:7:9];mat[3,:1:6]]
     mate[:,16:18]=rotr90(mat[:,16:18])

     return mate
 end

 ##This function moves the bottom of the cube 90 degrees counter-clockwise
 function d(mat)

     mate=copy(mat)

     mate[3,:1:12]=[mat[3,:7:12];mat[3,:4:6];mat[3,:1:3]]
     mate[:,16:18]=rotl90(mat[:,16:18])

     return mate
 end

 ##This function moves the front of the cube 90 degrees clockwise
 function f(mat)

     mate=copy(mat)

     mate[:,16]=mat[:,10]
     mate[:,7]=mat[:,16]
     mate[:,13]=mat[:,7]
     mate[:,10]=mat[:,13]

     mate[:,1:3]=rotr90(mat[:,1:3])

     return mate
 end

 ##This function moves the front of the cube 90 degrees counter-clockwise
 function fprime(mat)

     mate=copy(mat)

     mate[:,10]=mat[:,16]
     mate[:,16]=mat[:,7]
     mate[:,7]=mat[:,13]
     mate[:,13]=mat[:,10]

     mate[:,1:3]=rotl90(mat[:,1:3])

     return mate
 end

 ##This function moves the back of the cube 90 degrees clockwise
 function b(mat)

     mate=copy(mat)

     mate[:,18]=mat[:,12]
     mate[:,9]=mat[:,18]
     mate[:,15]=mat[:,9]
     mate[:,12]=mat[:,15]

     mate[:,4:6]=rotr90(mat[:,4:6])

     return mate
 end

 ##This function moves the back of the cube counter-clockwise
 function bprime(mat)

     mate=copy(mat)

     mate[:,12]=mat[:,18]
     mate[:,18]=mat[:,9]
     mate[:,9]=mat[:,15]
     mate[:,15]=mat[:,12]

     mate[:,4:6]=rotl90(mat[:,4:6])

     return mate
 end

 ##In the q-table a number signifying the move (1 through 12) will be passed to this function and the 
 ##corresponding number performs an operation on the cube.  
 function each_action(s)
     a=zeros(3,18,12)
     a[:,:,1]=r(s)
     a[:,:,2]=rprime(s)
     a[:,:,3]=l(s)
     a[:,:,4]=lprime(s)
     a[:,:,5]=f(s)
     a[:,:,6]=fprime(s)
     a[:,:,7]=b(s)
     a[:,:,8]=bprime(s)
     a[:,:,9]=u(s)
     a[:,:,10]=uprime(s)
     a[:,:,11]=d(s)
     a[:,:,12]=dprime(s)

     return a
 end

 ##Once completed a path will be rewarded.  This reward is spread recursively from the end reward back through
 ##the previous moves performed to complete the path.
 function res(y,i)


     if i<2
         return
     end

     y[i-1]+=(.9*y[i])
     res(y,i-1)
 end


 ##The cube is solved using a q-table and the bellman equation with rewards and penalties for an action 
 ##leading to a correct path or not

 function q_table_test(trying,cube)
     D=[]
     x=0
     ##There are 12 possible moves and the cube needs to be solved in 31 moves
     q=zeros(31,12)

     ##Once the path completes the tests stop.  
    while length(D)<1

     ##The moves for each path (up to 31 moves) are stored and if the cube is solved then the path is saved
     path=[]

     ##The rewards are saved to be recursively treated according to the Bellman equation
     rewards=[]
      x=1
      this_thing=trying

      ##The maximum moves allowed to solve the cube is 31.  The cube should ideally be solved in less moves.
     while x<=31

     ##Random drawing criteria.  If only the move leading to maximum value is used then the cube might
     ##not be solved

     epsilon=rand(0:.001:.75)

     if epsilon<.5
         action=rand(1:12)
         reward=q[x,action]
     else
          action=findmax(q[x,:])[2]
          reward=q[x,action]
     end

     ##The the action is performed on the cube
      transition=each_action(this_thing)

      newstate=transition[:,:,action]



     ##If the cube is solved then the 
     if newstate==cube
         q[x,action]=50
         push!(rewards,50.0)
         push!(path,action)
         push!(D,path)

         res(rewards,length(rewards))

         for j in 1:length(rewards)
             q[j,path[j]]+=rewards[j]
         end

         break
     else
         q[x,action]+=-.02
         push!(rewards,0)
         push!(path,action)
     end


     ##need it to go all the way up.


     x+=1
     this_thing=newstate
 end
 end

     return D,q
 end

 ##These following function calls serve the purpose of scrambling the cube.  They could be called in 
 ##any random order.
 trying=u(cube)
 trying=b(trying)
 trying=r(trying)
 trying=u(cube)
 trying=b(trying)
 trying=r(trying)
 trying=l(trying)
 trying=u(trying)

 ##Time is shown for a completed test.  The function also returns the path and the q-table
 @time begin
 a,bee=q_table_test(trying,cube)
 end

 2.390181 seconds (18.60 M allocations: 4.333 GiB, 19.30% gc time)
 Out[69]:
 (Any[Any[10, 4, 2, 8, 10]], [-11.38 -11.34 … -11.28 -11.3; -11.3 -11.32 … -11.32 -11.3; … ; -11.3 -11.3 … -11.3 -11.32; -11.3 -11.32 … -11.32 -11.28])

 a
  Any[10, 4, 2, 8, 10]

 for i in 1:31
    j=findmax(bee[i,:])[1]
    println(j)
 end

 21.48500000000016
 25.110000000000156
 29.140000000000153
 33.70000000000015
 100.0
 -11.279999999999848
 -11.259999999999849
 -11.299999999999848
 -11.279999999999848
 -11.279999999
 .
 .
 .
 .
 ##Check that the path solves the cube
 for i in 1:length(a[1])
 trying=each_action(trying)[:,:,a[1][i]]
 end

 trying

 1.0  1.0  1.0  2.0  2.0  2.0  3.0  3.0  …  4.0  5.0  5.0  5.0  6.0  6.0  6.0
 1.0  1.0  1.0  2.0  2.0  2.0  3.0  3.0     4.0  5.0  5.0  5.0  6.0  6.0  6.0
 1.0  1.0  1.0  2.0  2.0  2.0  3.0  3.0     4.0  5.0  5.0  5.0  6.0  6.0  6.0

