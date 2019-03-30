module Maker where

import qualified Data.ByteString.Lazy  as BL
import Data.Csv

writeRows :: IO ()
writeRows = write $ encode createRows

write :: BL.ByteString -> IO () 
write string = BL.writeFile "tmp/large.csv" string

createRows :: [(Int, String)]
createRows = [(x, "name" <> show x) | x <- [0..100000] ]
