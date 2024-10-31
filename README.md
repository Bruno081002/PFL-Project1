# PFL-Project1

## Project note:

## Auxiliar Functions



### `removeDuplicates`

> A recursive function that checks if the first element in a list is already present in the remaining elements.
> - If the element is present, the recursive call proceeds with the rest of the list, excluding the first element.
> - If the element is not present, it is added to the result, and the recursive call processes the rest of the list.

---

### `distPath`

> This function takes a `RoadMap` and a `Path`, returning a list of distances between adjacent cities in the path.  
> Example: Given `[city1, city2, city3]`, the output would be `[dist12, dist23]`.
> - First, it creates a list of tuples with adjacent cities.
> - Then, using `map`, it calculates the distance between each pair of cities in the tuples.

---

### `roadMapRec`

A recursive function that takes four parameters: `roadMap`, a list of cities, the current maximum number of adjacent cities, and an accumulator with cities that have the same number of adjacent cities.
- **Base case**: When the list of cities to check is empty, the function returns the accumulator.
- **Recursive case**:
  - It calculates the number of adjacent cities for the first city, `len`.
  - If `num < len`, the accumulator is set to the current city.
  - If `num > len`, the accumulator remains unchanged, and the current city is ignored.
  - Otherwise, the current city is added to the accumulator.

## Main FUnctions

### `Function 1`

> This function uses an auxiliary function to remove all duplicates from a list.  
> - To get all cities, we first create a list of all cities by taking the first (index 0) and second (index 1) values from each tuple in the `RoadMap`, using the `concatMap` function.
> - We then apply the duplicate removal function to ensure each city appears only once.


---

### Function 2:
> A function that return true if 2 cities are adjacent,. For two cities to be adjacent, they must appear together in the same tuple within the RoadMap
To achieve this we use the any function ,passing an auxiliar function that check if The first city in the tuple (index 0) matches one of the cities we are checking (city1), 
and the second city in the tuple (index 1) matches the other city (city2).
Since the graph is undirected, we also need to check the reverse.

---
### `Function 3`

> A function that calculates the distance between two cities.  
> - The distance between `city1` and `city2` can be found by retrieving the third value in the tuple `(city1, city2, Dist)` or `(city2, city1, Dist)`.

---

### `Function 4`

> A function that returns all cities adjacent to a given city.  
> - To achieve this, we use list comprehension to gather all cities that have the input city as one of the elements in their pair.

### `Function 5`

> This function takes two attributes: `RoadMap` and `city`.  
> - It checks if the path is null or contains only one value.
> - It verifies if there are any adjacent cities that do not have a route to others; if this is the case, it returns nothing.
> - Otherwise, it sums all the values in the list of distances calculated in `distPath`. The map is used to transform all 'Just' values into integers.

---
### `Function 6`
> This function calculates the list of cities that have more adjcent cities 
Basicly it just uses the auxiliar functiopn roadMapRec




### `Function 7`

> In this function, we check if the graph is strongly connected.  
> - A strongly connected graph is one in which every vertex is reachable from every other vertex. 
> - To achieve this, we implement an auxiliary function using breadth-first search (BFS).



### function 8:

### Function 9:

#### Tsp

The algoritm used was an algoritm based in a dynamic programing strategy that stores the stage of the proceced cities using a bitMask, with n bits. N is the number of cities in the graph.Let me give an exemplo so its easirer do understand.
When the first three cities are already visited the bit mask is 1110000.
The algoritm uses an adjancy matrix thsat stores the disntance of every adjancy city of the graph,so its easier to get the values of the distance between 2 cities
The fucntions tsp use some auxiliar functions and i will explain them:

Isconnected-Is a very importante function  that uses a dfs to serach if from a certen city it can reach all of other cities.
Dfs is a recursive function:
    The base case is when the input city is found it retuns the list of the cities found
    The recursive case uses a foldL,that add a list of a city to acumultation


