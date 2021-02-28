##Reinforcement Learning and Rubik's Cubes

The idea of learning from delayed rewards is the foundation of q-learning.  The central idea is that a problem can have certain states and each state will have an action that will lead to either a reward or penalty or no change in total reward at all.  A Rubik's cube has 12 possible move to perform.  To randomly search to solve would take too much memory and time.  Also to iteratively search by only accepting the path which has the highest reward would require too much memory and time.  The best way is to use both strategies, to search both randomly and iteratively.  

A q-table will first be initialized to be zero usually.  This is a matrix where the length of each row is the amount of possible moves.  The height of each column is the amount of decisions or moves that are allowed to be made to solve the initial state.  When an action does not result in a solved state then a negative reward is the result and the corresponding action and move position in the q-table receives this value.  If a solved state is achieved then the set reward is achieved.  The path used to solve the states is then recursively adjusted using the Bellman Equation:

<img width="344" alt="image" src="https://user-images.githubusercontent.com/58529391/109428063-18a80d80-79aa-11eb-84ce-11fc811ba6bf.png">

The idea behind the Bellman Equation is that the maximum reward at each action state is chosen that will result in a solved state.  An example of the rewards by action is 

```
 0.668297  0.125     0.1    0.145    0.165   0.215  0.27   0.0  
 0.29      0.671441  0.065  0.235    0.055   0.225  0.01   0.27 
 0.065     0.11      0.22   0.68549  0.11    0.23   0.235  0.08 
 0.05      0.17      0.01   0.05     0.9261  0.295  0.17   0.285
 0.3       0.255     0.015  0.145    0.01    0.235  0.005  0.894
 0.01      0.11      0.25   0.29     0.055   0.11   1.025  0.185
 0.27      0.07      0.205  0.13     0.075   0.935  0.065  0.21 
 0.275     0.1       0.285  0.095    1.04    0.195  0.225  0.01  
 ```
Using the maximum of each row the optimal path that achieves a solved state in this example is [1, 2, 4, 5, 8, 7, 6, 5].  This is a generic example and is for demonstration purposes.

Reinforcement learning is not a very effective way to solve a Rubik's cube.  A better use of reinforcement learning would be in training a computer to play a video game or to autonomously drive a car.  The following code is able to effectively solve a cube that is within 8-9 moves away from a solved cube.  This is achieved by scrambling a completed cube with 8-9 moves.  The code is ran until the cube is solved and is then proven to be solved.  This is also timed.  
