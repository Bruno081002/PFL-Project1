toAdjMatrix :: [City] -> RoadMap -> AdjMatrix
toAdjMatrix cities roadmap =
  array ((0, 0), (n - 1, n - 1)) [((i, j), distance roadmap (cities !! i) (cities !! j)) | i <- [0 .. n - 1], j <- [0 .. n - 1]]
  where
    n = length cities



baseCase :: AdjMatrix -> Int -> Int -> Path -> (Distance, Path)
baseCase adjMatrix currCity allVisited currPath
  | Just dist <- adjMatrix ! (currCity, 0) = (dist, reverse (show currCity : currPath))  -- Caminho válido de volta ao início
  | otherwise = (100000000, [])  -- Caminho inválido



getDistance :: Int -> Int -> AdjMatrix -> Distance
getDistance from to adj =
  case adj Data.Array.! (from, to) of
    Just dist -> dist  
    Nothing -> 100000 


auxTravelSales :: AdjMatrix -> Int -> Int -> Int -> Path -> (Distance, Path)
auxTravelSales adjMatrix visitedCities currcity visitAll actualpath
    | visitedCities == visitAll = baseCase adjMatrix currcity visitAll actualpath
    | otherwise = 
        let nMax = fst (snd (bounds adjMatrix)) 
            paths = [ (dist + newDist, newPath)
                        | city <- [0..nMax], not (visitedCities `testBit` city),
                          let dist = getDistance currcity city adjMatrix,
                          let (newDist, newPath) = auxTravelSales adjMatrix ( visitedCities `setBit` city) city visitAll (show currcity : actualpath)] 
            (minDist, minPath) = minimum paths 
        in  (minDist, minPath) 
