import Data.Array
import Data.Bits
import Data.List

-- PFL 2024/2025 Practical assignment 1

-- Uncomment the some/all of the first three lines to import the modules, do not change the code of these lines.

type City = String

type Path = [City]

type Distance = Int

type RoadMap = [(City, City, Distance)]

type AdjList = [(City, [(City, Distance)])]

type AdjMatrix = Array (Int, Int) (Maybe Distance)

-- auxiliar functions

removeduplicates :: (Eq a) => [a] -> [a]
removeduplicates [] = []
removeduplicates (x : xs)
  | x `elem` xs = removeduplicates xs
  | otherwise = x : removeduplicates xs

distPath :: RoadMap -> [City] -> [Maybe Distance] -- Gives a list with all dist in the path ex [city1,city2,city3,city4] gives [Dist12,Dist23,Dist34]
distPath roadMap path =
  let pairs = zip path (tail path) -- Create pairs of consecutive cities
   in map (\(city1, city2) -> distance roadMap city1 city2) pairs

roadMaprec :: RoadMap -> [City] -> Int -> [City] -> [City] -- Not sure about it
roadMaprec _ [] _ acc = acc
roadMaprec road (x : xs) num acc
  | num < len = roadMaprec road xs len [x]
  | num > len = roadMaprec road xs num acc
  | otherwise = roadMaprec road xs (len) (x : acc)
  where
    len = length (adjacent road x)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- strong connected functions

mydfs :: RoadMap -> [City] -> [City] -> [City]
mydfs _ [] visited = visited
mydfs themap (atual : stack) visited
  | atual `elem` visited = mydfs themap stack visited
  | otherwise = mydfs themap (adjacentCities ++ stack) (atual : visited)
  where
    adjacentCities = [city | (city, _) <- adjacent themap atual]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- shortest path functions

dfsShortestPath :: RoadMap -> City -> City -> Path -> Distance -> [(Path, Distance)] -> [(Path, Distance)]
dfsShortestPath theamap sour dest path dist allpaths
  | dist > googdistances = allpaths
  | sour == dest = if (dist < googdistances) then [(path ++ [sour], dist)] else (path ++ [sour], dist) : allpaths
  | otherwise = foldl (\acc (unvisited, edgeDist) -> dfsShortestPath theamap unvisited dest (path ++ [sour]) (dist + edgeDist) acc) allpaths adjunvisited
  where
    adjunvisited = [(unvisited, dist) | (unvisited, dist) <- adjacent theamap sour, unvisited `notElem` path]
    googdistances = if null allpaths then (maxBound :: Int) else snd (head allpaths)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- tha main functions

cities :: RoadMap -> [City]
cities themap = removeduplicates (concat (map (\(x, y, _) -> [x, y]) themap)) -- modifiy this line to implement the solution, for each exercise not solved, leave the function definition like this

areAdjacent :: RoadMap -> City -> City -> Bool
areAdjacent themap city1 city2 = any (\(x, y, _) -> (x == city1 && y == city2) || (x == city2 && y == city1)) themap

distance :: RoadMap -> City -> City -> Maybe Distance
distance themap city1 city2 =
  let result = [Just dist | (x, y, dist) <- themap, (x == city1 && y == city2) || (x == city2 && y == city1)]
   in if null result
        then Nothing
        else head result

adjacent :: RoadMap -> City -> [(City, Distance)]
adjacent themap city1 = [(if x == city1 then y else x, dist) | (x, y, dist) <- themap, x == city1 || y == city1]

pathDistance :: RoadMap -> Path -> Maybe Distance
pathDistance roadMap path
  | null path || length path == 1 = Just 0
  | any (== Nothing) dists = Nothing
  | otherwise = Just (sum (map (\(Just d) -> d) dists))
  where
    dists = distPath roadMap path

rome :: RoadMap -> [City] -- get nim road for each city lengh adjacent city
rome roadMap = roadMaprec roadMap (cities roadMap) 0 [] -- Pass the roadmap the lis of cities

isStronglyConnected :: RoadMap -> Bool
isStronglyConnected themap = length (mydfs themap [head (cities themap)] []) == length (cities themap)

shortestPath :: RoadMap -> City -> City -> [Path]
shortestPath themap city1 city2
  | city1 == city2 = [[city1]]
  | null (map fst (dfsShortestPath themap city1 city2 [] 0 [])) = []
  | otherwise = map fst (dfsShortestPath themap city1 city2 [] 0 [])

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
toAdjMatrix :: RoadMap -> AdjMatrix
toAdjMatrix mapa = Data.Array.array limites [((i, j), distance mapa (show i) (show j)) 
                                             | i <- [0..numCidades - 1], j <- [0..numCidades - 1]]
  where
    ordenadas = Data.List.sort (cities mapa)
    numCidades = length ordenadas
    limites = ((0, 0), (numCidades - 1, numCidades - 1))


-- Check if all cities are connected starting from a specific city.

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



-- Base case for TSP when all cities have been visited.
baseCase :: AdjMatrix -> Int -> Int -> Path -> (Distance, Path)
baseCase adjMatrix currCity allVisited currPath
  | Just distance <- adjMatrix ! (currCity, 0) = (distance, reverse (show currCity : currPath))  
  | otherwise = (9999999999, [])  

getDistFromAjd :: AdjMatrix -> Int -> Int -> Distance
getDistFromAjd adjM city1 city2 
  | Just distance <- adjM ! (city1, city2) = distance  
  | otherwise = 9999999999


-- Recursive function to find the minimum path for TSP.
minByDist :: (Int, Path) -> (Int, Path) -> Ordering
minByDist (dist1, _) (dist2, _) = compare dist1 dist2

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

-- Main function to solve the Traveling Salesman Problem (TSP).
travelSales :: RoadMap -> Path
travelSales road =
  if not (isConnected adjM 0)
    then [] -- Handle empty list or unconnected graph case
    else snd (tspAdjAux adjM visited currCity allVisited path) ++ ["0"]
  where
    lCitys = cities road
    adjM = toAdjMatrix road
    visited = Data.Bits.bit 0
    currCity = 0
    allVisited = (1 `shiftL` length lCitys) - 1
    path = []

tspBruteForce :: RoadMap -> Path
tspBruteForce = undefined -- only for groups of 3 people; groups of 2 people: do not edit this function
-- Some graphs to test your work

gTest1 :: RoadMap
gTest1 = [("7", "6", 1), ("8", "2", 2), ("6", "5", 2), ("0", "1", 4), ("2", "5", 4), ("8", "6", 6), ("2", "3", 7), ("7", "8", 7), ("0", "7", 8), ("1", "2", 8), ("3", "4", 9), ("5", "4", 10), ("1", "7", 11), ("3", "5", 14)]

gTest2 :: RoadMap
gTest2 = [("0", "1", 10), ("0", "2", 15), ("0", "3", 20), ("1", "2", 35), ("1", "3", 25), ("2", "3", 30)]

gTest3 :: RoadMap -- unconnected graph
gTest3 = [("0", "1", 4), ("2", "3", 2)]

gTest5 :: RoadMap
gTest5 = [("0", "1", 4), ("0", "2", 1), ("2", "3", 1), ("3", "4", 1), ("4", "1", 1), ("0", "5", 2), ("5", "1", 2)]
