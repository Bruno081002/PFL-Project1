import  Data.List
import  Data.Array
import  Data.Bits


-- PFL 2024/2025 Practical assignment 1

-- Uncomment the some/all of the first three lines to import the modules, do not change the code of these lines.

type City = String

type Path = [City]

type Distance = Int

type RoadMap = [(City, City, Distance)]

type AdjList = [(City,[(City,Distance)])]

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
roadMaprec road (x : xs) num acc =
  let adj = adjacent road x
   in if num < length adj
        then roadMaprec road xs (length adj) [x]
        else
          if num > length adj
            then roadMaprec road xs num acc
            else roadMaprec road xs (length adj) (x : acc)
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
  | otherwise =
      let dists = distPath roadMap path
       in if any (== Nothing) dists
            then Nothing
            else Just (sum (map (\(Just d) -> d) dists)) -- THis map is to extract only the just, it will extract all values because before entering the else
            -- Its garanted that the list dont have nothings, so i use the map just to tranform all values in ints
            -- Need to ask teacher


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

toAdjMatrix :: [City] -> RoadMap -> AdjMatrix
toAdjMatrix cities roadmap = array ((0, 0), (n-1, n-1))
    [((i, j), distance roadmap (cities !! i) (cities !! j)) | i <- [0..n-1], j <- [0..n-1]]
  where
    n = length cities
    
-- Check is all cities are conected from city zero
isConnected :: AdjMatrix -> Int -> Bool
isConnected adjMatrix startCity = length visitedCities == numCities
  where
    n = fst (snd (bounds adjMatrix))
    numCities = n + 1
    visitedCities = dfs startCity []

    neighbors :: Int -> [Int]
    neighbors city = [nextCity | nextCity <- [0..n], isConnectedCity city nextCity]

    isConnectedCity :: Int -> Int -> Bool
    isConnectedCity city1 city2 = case adjMatrix ! (city1, city2) of
                                     Nothing -> False
                                     Just _  -> True
    dfs :: Int -> [Int] -> [Int]
    dfs city visited
      | city `elem` visited = visited
      | otherwise = foldl (flip dfs) (city : visited) (neighbors city)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


baseCase :: AdjMatrix -> Int -> (Int, [Int])
baseCase adjMatrix currentCity =
  case adjMatrix ! (currentCity, 0) of
    Just d  -> (d, [0])  -- Return distance and path back to start
    Nothing -> (maxBound, [])  -- No path back to start

-- Recursive TSP function
tsp :: AdjMatrix -> Int -> Int -> Int -> (Int, [Int])
tsp adjMatrix visited currCity allVisited
  | visited == allVisited = baseCase adjMatrix currCity
  | otherwise = explorePaths adjMatrix visited currCity allVisited

-- Explore possible paths from the current city
explorePaths :: AdjMatrix -> Int -> Int -> Int -> (Int, [Int])
explorePaths adjMatrix visited currentCity allVisited =
  let n = fst (snd (bounds adjMatrix)) + 1
  in minimumBy (\(d1, _) (d2, _) -> compare d1 d2) 
     [ let (nextCost, subPath) = exploreNext adjMatrix visited currentCity nextCity allVisited
       in (nextCost, nextCity : subPath)
     | nextCity <- [0..n-1],not (visited `testBit` nextCity),nextCity /= currentCity
     ]
-- Explore the next city
exploreNext :: AdjMatrix -> Int -> Int -> Int -> Int -> (Int, [Int])
exploreNext adjMatrix visited currentCity nextCity allVisited =
  case adjMatrix ! (currentCity, nextCity) of
    Just d ->
      let (tspNextCost, tsPSubPath) = tsp adjMatrix (visited `setBit` nextCity) nextCity allVisited
      in (d + tspNextCost, tsPSubPath) 
    
    Nothing -> (maxBound, [])

travelSales :: RoadMap -> Path
travelSales roadmap =
  let citiesL = cities roadmap
      n = length citiesL
      adjMatrix = toAdjMatrix citiesL roadmap
      allVisited = (1 `shiftL` n) - 1
  in if isConnected adjMatrix 0
     then
       let (cost, indexPath) = tsp adjMatrix 1 0 allVisited
           finalPath = if last indexPath == 0
                       then 0 : indexPath       -- `indexPath` já termina em 0, então não adicionar outro
                       else 0 : indexPath ++ [0] -- `indexPath` não termina em 0, adicionar um
       in if cost == maxBound
          then [] 
          else map (citiesL !!) finalPath
     else []
--------------------------------------------------------------------------------------------
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
gTest5 = [("0","1",4),("0","2",1),("2","3",1), ("3","4",1), ("4", "1", 1), ("0","5",2),("5","1",2)]
