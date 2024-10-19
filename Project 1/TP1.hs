import Data.Array qualified
import Data.Array qualified as Array
import Data.List qualified
import Distribution.Simple.Program.HcPkg qualified as Array
import GHC.Arr (Array (Array))

-- import qualified Data.Array
-- import qualified Data.Bits

-- PFL 2024/2025 Practical assignment 1

-- Uncomment the some/all of the first three lines to import the modules, do not change the code of these lines.

type City = String

type Path = [City]

type Distance = Int

type RoadMap = [(City, City, Distance)]

type AdjMatrix = Data.Array.Array (Int, Int) (Maybe Distance)

-- auxiliar functions
removeduplicates :: (Eq a) => [a] -> [a]
removeduplicates [] = []
removeduplicates (x : xs)
  | x `elem` xs = removeduplicates xs
  | otherwise = x : removeduplicates xs

-- distanceBetween :: RoadMap -> City -> City -> Maybe Distance
-- distanceBetween themap city1 city2 = let result = [distance | (x,y,distance) <- themap, x == city1 && y == city2]
--                                 in if result == [] then Nothing
--                                 else head result
-- Array.listArray receive 2 tuples, the indice start and the end, then receives the values passed

roadMapToAdjMatrix :: RoadMap -> AdjMatrix
roadMapToAdjMatrix road = Array.listArray ((0, 0), (n - 1, n - 1)) values
  where
    city = cities road
    n = length city
    values = [distance road (city !! i) (city !! j) | i <- [0 .. n - 1], j <- [0 .. n - 1]]

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

mydfs :: RoadMap -> [City] -> [City] -> [City]
mydfs _ [] visited = visited
mydfs themap (atual : stack) visited
  | atual `elem` visited = mydfs themap stack visited
  | otherwise = mydfs themap (adjacentCities ++ stack) (atual : visited)
  where
    adjacentCities = [city | (city, _) <- adjacent themap atual]


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- priotity queue
type Priorityqueue = [((Path, Distance), Int)]

enqueue :: Priorityqueue -> ((Path, Distance), Int) -> Priorityqueue
enqueue [] x = [x]
enqueue ((a,b) : x) (c,d)
  | d < b = (c,d) : (a,b) : x
  | otherwise = (a,b) : enqueue x (c,d)

dequeue :: Priorityqueue -> (Priorityqueue, (Path, Distance)) 
dequeue [] = ([], ([], 0))
dequeue ((path, _):xs) = (xs, path)


-- djikstra
djikstra :: RoadMap -> City -> City -> [(Path, Distance)]
djikstra [] _ _ = []
djikstra themap source destination = inicialcost : djikstra themap source destination
  where
    inicialcost = ([source], 0) -- inicializamos o custo da source a 0
    allcities = cities themap
    infinitecosts = [(city, maxBound :: Int) | city <- allcities] -- inicializamos os custos de todos os vertices com excepcao da source com infinito
    costs = enqueue [] inicialcost -- inicializamos a fila de prioridade com o custo inicial 
    visited = [] -- lista de visitados

   
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- tha main functions

cities :: RoadMap -> [City]
cities themap = removeduplicates (concat (map (\(x, y, _) -> [x, y]) themap)) -- modifiy this line to implement the solution, for each exercise not solved, leave the function definition like this

areAdjacent :: RoadMap -> City -> City -> Bool
areAdjacent themap city1 city2 = any (\(x, y, _) -> (x == city1 && y == city2) || (x == city2 && y == city1)) themap

distance :: RoadMap -> City -> City -> Maybe Distance
distance themap city1 city2
  | city1 == city2 = Just 0
  | otherwise =
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

-- pathDistance themap thepath = if thepath == [] then Just 0 else if length thepath == 1 then Just 0 else if length thepath == 2 then distance themap if distanceBetween themap (head thepath) (last thepath) == Nothing then Nothing else Just (the (distanceBetween themap (head thepath) (last thepath))) else if distanceBetween themap (head thepath) (head (tail thepath)) == Nothing then Nothing else if pathDistance themap (tail thepath) == Nothing then Nothing else Just (the (distanceBetween themap (head thepath) (head (tail thepath))) + the (pathDistance themap (tail thepath)))

rome :: RoadMap -> [City] -- get nim road for each city lengh adjacent city
rome roadMap = roadMaprec roadMap (cities roadMap) 0 [] -- Pass the roadmap the lis of cities

isStronglyConnected :: RoadMap -> Bool
isStronglyConnected themap = length (mydfs themap [head (cities themap)] []) == length (cities themap)

shortestPath :: RoadMap -> City -> City -> [Path]
shortestPath themap city1 city2 = undefined

travelSales :: RoadMap -> Path
travelSales = undefined

tspBruteForce :: RoadMap -> Path
tspBruteForce = undefined -- only for groups of 3 people; groups of 2 people: do not edit this function

-- Some graphs to test your work
gTest1 :: RoadMap
gTest1 = [("7", "6", 1), ("8", "2", 2), ("6", "5", 2), ("0", "1", 4), ("2", "5", 4), ("8", "6", 6), ("2", "3", 7), ("7", "8", 7), ("0", "7", 8), ("1", "2", 8), ("3", "4", 9), ("5", "4", 10), ("1", "7", 11), ("3", "5", 14)]

gTest2 :: RoadMap
gTest2 = [("0", "1", 10), ("0", "2", 15), ("0", "3", 20), ("1", "2", 35), ("1", "3", 25), ("2", "3", 30)]

gTest3 :: RoadMap -- unconnected graph
gTest3 = [("0", "1", 4), ("2", "3", 2)]
