-- PFL 2024/2025 Practical assignment 1

-- Uncomment the some/all of the first three lines to import the modules, do not change the code of these lines.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Module declaration
import Data.Array
import Data.Bits
import Data.List
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Types

-- Represents a city by a `String` identifier.
type City = String

-- Represents a path by a list of cities.
type Path = [City]

-- Represents a distance by an `Int` value.
type Distance = Int

-- Represents a roadmap by a list of triples, where each triple represents a road between two cities and its distance.
type RoadMap = [(City, City, Distance)]

-- Represents an adjacency list by a list of pairs, where each pair represents a city and its adjacent cities with their distances.
type AdjList = [(City, [(City, Distance)])]

-- Represents an adjacency matrix by an array of pairs, where each pair represents a pair of cities and the distance between them.
type AdjMatrix = Array (Int, Int) (Maybe Distance)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Auxiliar functions

-- The goal is to remove duplicates from a list.
-- Removes duplicates from a list, preserving the first occurrence.
--  xs The input list.
-- return A list with duplicates removed.
-- complexity O(n^2), since it uses `elem` for each element.
removeduplicates :: (Eq a) => [a] -> [a]
removeduplicates [] = []
removeduplicates (x : xs)
  | x `elem` xs = removeduplicates xs
  | otherwise = x : removeduplicates xs


-- The goal is to get the distance between two cities.
-- Gets distances between consecutive cities in a path.
-- roadMap The road map with city distances.
-- path The list of cities representing the path.
-- return A list of `Maybe Distance` values for each pair of consecutive cities.
-- complexity O(m * n), where `m` is the path length and `n` is the number of routes.
distPath :: RoadMap -> [City] -> [Maybe Distance] 
distPath roadMap path =
  let pairs = zip path (tail path) 
   in map (\(city1, city2) -> distance roadMap city1 city2) pairs


-- The goal is to find the city (or cities) with the largest number of adjacent connections.
-- Finds the city (or cities) with the largest number of adjacent connections.
-- road The road map with city distances.
-- cities The list of cities to evaluate.
-- num The maximum number of adjacent cities found so far.
-- acc The list of cities with the maximum number of adjacent cities.
-- return The list of cities with the maximum number of adjacent cities.
-- complexity O(n * m), where `n` is the number of cities and `m` is the average number of connections per city.
roadMaprec :: RoadMap -> [City] -> Int -> [City] -> [City] 
roadMaprec _ [] _ acc = acc
roadMaprec road (x : xs) num acc
  | num < len = roadMaprec road xs len [x]
  | num > len = roadMaprec road xs num acc
  | otherwise = roadMaprec road xs (len) (x : acc)
  where
    len = length (adjacent road x)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Strongly connected auxiliar functions

-- The goal is to perform a depth-first search (DFS) traversal of a graph.
-- Performs a depth-first search (DFS) traversal of a graph.
-- themap The road map with city distances.
-- stack The stack of cities to visit. 
-- visited The list of visited cities.
-- return The list of visited cities.
-- complexity 0(V + E), where `V` is the number of vertices and `E` is the number of edges.
mydfs :: RoadMap -> [City] -> [City] -> [City]
mydfs _ [] visited = visited
mydfs themap (atual : stack) visited
  | atual `elem` visited = mydfs themap stack visited
  | otherwise = mydfs themap (adjacentCities ++ stack) (atual : visited)
  where
    adjacentCities = [city | (city, _) <- adjacent themap atual]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Shorteste path functions

-- The goal is to find the shortest path between two cities.
-- Finds the shortest path between two cities.
-- theamap The road map with city distances.
-- sour The source city.
-- dest The destination city.
-- path The current path.
-- dist The current distance.
-- allpaths The list of all paths found so far.
-- return The list of all paths found so far.
-- complexity O(V + E), where `V` is the number of vertices and `E` is the number of edges.
dfsShortestPath :: RoadMap -> City -> City -> Path -> Distance -> [(Path, Distance)] -> [(Path, Distance)]
dfsShortestPath theamap sour dest path dist allpaths
  | dist > googdistances = allpaths
  | sour == dest = if (dist < googdistances) then [(path ++ [sour], dist)] else (path ++ [sour], dist) : allpaths
  | otherwise = foldl (\acc (unvisited, edgeDist) -> dfsShortestPath theamap unvisited dest (path ++ [sour]) (dist + edgeDist) acc) allpaths adjunvisited
  where
    adjunvisited = [(unvisited, dist) | (unvisited, dist) <- adjacent theamap sour, unvisited `notElem` path]
    googdistances = if null allpaths then (maxBound :: Int) else snd (head allpaths)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TSP auxiliar functions

-- The goal is to convert a road map to an adjacency matrix.
-- Converts a road map to an adjacency matrix.
-- mapa The road map with city distances.
-- return The adjacency matrix.
-- complexity O(n^2), where `n` is the number of cities.
toAdjMatrix :: RoadMap -> AdjMatrix
toAdjMatrix mapa = Data.Array.array limites [((i, j), distance mapa (show i) (show j)) 
                                             | i <- [0..numCidades - 1], j <- [0..numCidades - 1]]
  where
    ordenadas = Data.List.sort (cities mapa)
    numCidades = length ordenadas
    limites = ((0, 0), (numCidades - 1, numCidades - 1))


-- The goal is to check if a city is connected to another city.
-- Checks if a city is connected to another city.
-- adjMatrix The adjacency matrix.
-- startCity The starting city.
-- return `True` if the cities are connected, `False` otherwise.  
-- complexity 0(V + E), where `V` is the number of vertices and `E` is the number of edges.
isConnected :: AdjMatrix -> Int -> Bool
isConnected adjMatrix startCity = length visitedCities == numCities
  where
    (_, (n, _)) = bounds adjMatrix
    numCities = n + 1
    visitedCities = dfs startCity []

    neighbors :: Int -> [Int]
    neighbors city = [nextCity | nextCity <- [0 .. n], isConnectedCity city nextCity]

    isConnectedCity :: Int -> Int -> Bool
    isConnectedCity city1 city2 = case adjMatrix ! (city1, city2) of
      Nothing -> False
      Just _ -> True

    dfs :: Int -> [Int] -> [Int]
    dfs city visited
      | city `elem` visited = visited
      | otherwise = foldl (\acc next -> dfs next acc) (city : visited) (neighbors city)



-- The goal is to find the base case for the TSP.
-- Finds the base case for the TSP.
-- adjMatrix The adjacency matrix.
-- currCity The current city.
-- allVisited The bitmask of all visited cities.
-- currPath The current path.
-- return The distance and path for the base case.
-- complexity O(1).
baseCase :: AdjMatrix -> Int -> Int -> Path -> (Distance, Path)
baseCase adjMatrix currCity allVisited currPath
  | Just distance <- adjMatrix ! (currCity, 0) = (distance, reverse (show currCity : currPath))  
  | otherwise = (9999999999, [])  


-- The goal is to get the distance between two cities.
-- Gets the distance between two cities.
-- adjM The adjacency matrix.
-- city1 The source city.
-- city2 The destination city.
-- return The distance between the cities.
-- complexity O(1).
getDistFromAjd :: AdjMatrix -> Int -> Int -> Distance
getDistFromAjd adjM city1 city2 
  | Just distance <- adjM ! (city1, city2) = distance  
  | otherwise = 9999999999


-- The goal is to find the minimum distance by comparing two paths.
-- Compares two paths by their distances.
-- (dist1, _) The first path distance and path.
-- (dist2, _) The second path distance and path.
-- return The ordering of the paths by distance.
-- complexity O(1).
minByDist :: (Int, Path) -> (Int, Path) -> Ordering
minByDist (dist1, _) (dist2, _) = compare dist1 dist2

-- The goal is to find the shortest path for the TSP.
-- Finds the shortest path for the TSP.
-- adjMatrix The adjacency matrix.
-- visitedCities The bitmask of visited cities.
-- currCity The current city.
-- allVisited The bitmask of all visited cities.
-- currPath The current path.
-- return The distance and path for the shortest path.
-- complexity O(n^2 * 2^n), where `n` is the number of cities.
tspAdjAux :: AdjMatrix -> Int -> Int -> Int -> Path -> (Distance, Path)
tspAdjAux adjMatrix visitedCities currCity allVisited currPath
  | visitedCities == allVisited = baseCase adjMatrix currCity allVisited currPath
  | otherwise =
      let nMax = fst (snd (bounds adjMatrix))
          paths =
            [ (d + newD, newPath)
              | c <- [0 .. nMax],
                not (visitedCities `testBit` c),
                let d = getDistFromAjd adjMatrix currCity c,
                let (newD, newPath) = tspAdjAux adjMatrix (visitedCities `setBit` c) c allVisited (show currCity : currPath)
            ]
          (minDist, resultPath) = minimumBy minByDist paths
      in (minDist, resultPath)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Main functions

-- The goal is to find the cities in a roadmap.
-- Finds the cities in a roadmap.
-- themap The road map with city distances.
-- return The list of cities in the roadmap.
-- complexity O(n^2), do to removeduplicates.
cities :: RoadMap -> [City]
cities themap = removeduplicates (concat (map (\(x, y, _) -> [x, y]) themap)) 

-- The goal is to check if two cities are adjacent.
-- Checks if two cities are adjacent.
-- themap The road map with city distances.
-- city1 The first city.
-- city2 The second city.
-- return `True` if the cities are adjacent, `False` otherwise.
-- complexity O(n), where `n` is the number of routes.
areAdjacent :: RoadMap -> City -> City -> Bool
areAdjacent themap city1 city2 = any (\(x, y, _) -> (x == city1 && y == city2) || (x == city2 && y == city1)) themap

-- The goal is to find the distance between two cities.
-- Finds the distance between two cities.
-- themap The road map with city distances.
-- city1 The first city.
-- city2 The second city.
-- return The distance between the cities, or `Nothing` if they are not adjacent.
-- complexity O(n), where `n` is the number of routes.
distance :: RoadMap -> City -> City -> Maybe Distance
distance themap city1 city2 =
  let result = [Just dist | (x, y, dist) <- themap, (x == city1 && y == city2) || (x == city2 && y == city1)]
   in if null result
        then Nothing
        else head result

-- The goal is to find the adjacent cities of a city.
-- Finds the adjacent cities of a city.
-- themap The road map with city distances.
-- city1 The city.
-- return The list of adjacent cities and their distances.
-- complexity O(n), where `n` is the number of routes.
adjacent :: RoadMap -> City -> [(City, Distance)]
adjacent themap city1 = [(if x == city1 then y else x, dist) | (x, y, dist) <- themap, x == city1 || y == city1]

-- The goal is to find the distance of a path.
-- Finds the distance of a path.
-- roadMap The road map with city distances.
-- path The list of cities representing the path.
-- return The distance of the path, or `Nothing` if the path is invalid. 
-- complexity O(n), where `n` is the number of cities in the path.
pathDistance :: RoadMap -> Path -> Maybe Distance
pathDistance roadMap path
  | null path || length path == 1 = Just 0
  | any (== Nothing) dists = Nothing
  | otherwise = Just (sum (map (\(Just d) -> d) dists))
  where
    dists = distPath roadMap path


--- The goal is to find the cities based on their adjacency in the road map.
-- Initializes the process to accumulate cities based on their adjacency count.
-- roadMap The road map containing the distances between cities.
-- return A list of cities processed according to their adjacency.
-- complexity O(V * E), where `V` is the number of cities and `E` is the number of roads (edges) in the road map.
rome :: RoadMap -> [City] 
rome roadMap = roadMaprec roadMap (cities roadMap) 0 [] 

-- The goal is to check if a road map is strongly connected.
-- Checks if a road map is strongly connected.
-- themap The road map with city distances.
-- return `True` if the road map is strongly connected, `False` otherwise.
-- complexity O(V + E), where `V` is the number of vertices and `E` is the number of edges.
isStronglyConnected :: RoadMap -> Bool
isStronglyConnected themap = length (mydfs themap [head (cities themap)] []) == length (cities themap)


-- The goal is to find the shortest path between two cities.
-- Finds the shortest path between two cities.
-- themap The road map with city distances.
-- city1 The source city.
-- city2 The destination city.
-- return The list of shortest paths between the cities.
-- complexity O(V + E), where `V` is the number of vertices and `E` is the number of edges.
shortestPath :: RoadMap -> City -> City -> [Path]
shortestPath themap city1 city2
  | city1 == city2 = [[city1]]
  | null (map fst (dfsShortestPath themap city1 city2 [] 0 [])) = []
  | otherwise = map fst (dfsShortestPath themap city1 city2 [] 0 [])


-- The goal is to solve the Traveling Salesman Problem (TSP) using an adjacency matrix representation of the road map.
-- Finds the shortest possible route that visits each city exactly once and returns to the starting city.
-- road The road map containing the distances between cities.
-- return A list representing the shortest path that visits all cities and returns to the start.
-- complexity O(n^2 * 2^n), where `n` is the number of cities, due to the recursive exploration of paths.
travelSales :: RoadMap -> Path
travelSales road =
  if not (isConnected adjM 0)
    then [] 
    else snd (tspAdjAux adjM visited currCity allVisited path) ++ ["0"]
  where
    lCitys = cities road
    adjM = toAdjMatrix road
    visited = Data.Bits.bit 0
    currCity = 0
    allVisited = (1 `shiftL` length lCitys) - 1
    path = []

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TSP using brute force for groups of 3 people
-- tspBruteForce :: RoadMap -> Path
-- tspBruteForce = undefined -- only for groups of 3 people; groups of 2 people: do not edit this function
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Some graphs to test your work


gTest1 :: RoadMap
gTest1 = [("7", "6", 1), ("8", "2", 2), ("6", "5", 2), ("0", "1", 4), ("2", "5", 4), ("8", "6", 6), ("2", "3", 7), ("7", "8", 7), ("0", "7", 8), ("1", "2", 8), ("3", "4", 9), ("5", "4", 10), ("1", "7", 11), ("3", "5", 14)]

gTest2 :: RoadMap
gTest2 = [("0", "1", 10), ("0", "2", 15), ("0", "3", 20), ("1", "2", 35), ("1", "3", 25), ("2", "3", 30)]

gTest3 :: RoadMap -- unconnected graph
gTest3 = [("0", "1", 4), ("2", "3", 2)]

gTest5 :: RoadMap
gTest5 = [("0", "1", 4), ("0", "2", 1), ("2", "3", 1), ("3", "4", 1), ("4", "1", 1), ("0", "5", 2), ("5", "1", 2)]


gTest6 :: RoadMap
gTest6 = [("0", "1", 5), ("1", "3", 5), ("0", "2", 5), ("2", "3", 5), ("1", "3", 25), ("2", "3", 30)]--Test the shortest path, 0-3
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------