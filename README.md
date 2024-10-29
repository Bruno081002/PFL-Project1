# PFL-Project1

## Project note:


### Function 1:
>We use a auxiliar Function to remove all duplicates in a list:
    Its a recusive Function that check if the first element in a list,
        If it is present, the recursive call proceeds with the rest of the list, excluding the first element.
        If it is not present, the first element is added to the result, and the recursive call processes the rest of the list. 
        To get all the cities, we fisrt create a list with all cities, which are the first (index 0) and second (index 1) values of each tuple in the RoadMap,using concatMap Function
Then we apply the  remove all duplicates.

### Function 2:
> A function that return true if 2 cities are adjacent,. For two cities to be adjacent, they must appear together in the same tuple within the RoadMap
To achieve this we use the any function ,passing an auxiliar function that check if The first city in the tuple (index 0) matches one of the cities we are checking (city1), 
and the second city in the tuple (index 1) matches the other city (city2).
Since the graph is undirected, we also need to check the reverse.


### Function 3.
> Function that calculate the distance between 2 cities,
the distance between city 1 and city 2 can be checked by geting the third value of tuple (city1,city2,Dist) or (city2,city1,Dist) .

### Function 4:
> returns the cities adjacent to a particular city, to achive this we use list compreension to get all cities that have the input city as pair

### function 5:
> Racicionio:

### function 7:
> In the function 7 we have to see if the graph is strongly connected, as we know that strongly connected graphs are graph that every vertez is reached from every other vertex, to do that we implemented an auxiliar function that is bfs to 


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

