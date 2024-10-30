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

##### Using adjancy matrex

building the algoritm 

Tsp using dynamic programing and adjacent matrix,

Explicação do algoritmo do tsp:


Tsp-O algoritmo usado é um algoritm que usa programação dinamica para a diminuicao do numero de calculos realizados em pequenas 
operacoes recursivas.Desta forma sao armazenados  distancia minima entre I J e o seu respetivo caminho,este caminho é armazenado usando
uma bitMask que contem as cidades visitadas a 1.
    bitMask-Esta pode armazenar 2^n bits,n é o numero de cidades
Atributos da funcao Tsp:
    AdjMatrix-Matrix que contem as cidades e as suas distancias
    visited-BiTMask explicada em cima 
    cuurentcity-A cidade atual,cidade que esta a ser explorda
    AllVisited-representa a bitMask com todas as cidades visistadas
TSP:

    funcao principal que chama todas as outras funcoes auxiliares
    Esta funcao tem 2 casos, um que verifica se a bitMask visited esta com as cidades ja todas visitadas

    Se for o fim do tsp chama Basecase:

    Em que verifica se existe um caminho entre a ultima cidade encontrada e a primeira cidade 
        Se existir retorna o segmento do caminho e a distancia
        Se nao existir retorna um maxBound,para o tsp nao selecionar este caso


    Se nao for o fim chama ExplorePath

    Primeiro o n-peite obter as dimenesoes da matrix,usa a funcao bounds que retorna uma tupla com as dimenesoes ((0,0),(n,n))
    snd-obtem a tupla de index maiores 
    fst-obtem o primeiro elemnto da tupla

    Depois vem  parte imporante do algoritmo em que usamos minimuBy-
    funcao que extrai o valor minimo de uma lista usando um comparador customizado-Pretendemos compara o primeiro valor de cada tupla-cost 
    O minimby é aplicado numa lista de tuplas formada por um cost,path:
    Esta lista de tuplas e formado por todos os possiveis caminhos entre a cidade atual e todas as possiveis proximas cidades
        NextCIty: 
                Nao pode ser a cidade atual
                Nao pode estar visitada na bit Mask
    Os valores de cost e path sao obtidos apartir da funcao ExploreNext

    Funcao ExploreNext:
        funcao que procura a distancia entre a cidade atual e a proxima cidade
            Se encontra distancia-
                faz uma chamada recursivas a tsp-em que atualiza a bit mask e marca a nova cidade como visitada
                Passa a NextCIty como currentCity 
                Resultado:
                (d + nextCost, nextCity : subPath)
            
                Calcula o cost total-adiciona d ao nextCost calculado pelo tsp-Representada o custo total entre a currcity e a nextCIty
                Reconstroi o path-adiciona a cidade processada ao subPath,subPath e o caminho processado anteriomente para chegar a currcity
           Se nao encontrar distancia-coloca maxBound para que o explorePath nao selecione esta cidade



travelSales 

    funcao principal que evoca tsp e todas as outras funcoes necessarias para a utilização do tsp
    Cities pra obter as cidades
    AdjMatrix
    calcular mascara AllVisited
    utilizar a funcao isconnected para apenas realizar o algoritm caso o grafo seja conecto
    e no fim do tsp,realiza algumas alteraçoes no path:
    then 0 : indexPath      
     else 0 : indexPath ++ [0]
    Este caso, foi pq num dos testes utilizados o ultimo valor repetia-se e nao consegui encontraar o motivo do erro
    por isos fiz esta operação 
    NO fiz faço uma operacoes de map para que cada cidade obtenha o valor da string destinada,pois eu processo as cidades como int 
    ao longo das funcoes porem no roadMap sao tudo strings  
    
Funcao auxiliar isconnected:
    funcao que verifica se o grafo é connected-verifica se todas as cidades sao alcansaveis apartir da primeira cidade
    Utiliza uma funcao neiboarss que retorna uma lista com cidades visitadas  

    depois utiliza a funcao dfs itera por todos os nos alcansaveis apatir do primeiro
    

    Caso os nos obtidos pela dfs==numcity quer dizer que é connected


    
Funcao auxiliar to AdjMatrix-tranforma um roadMap é uma matrix de adjacencia:

