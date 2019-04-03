{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}

module SimpleParser (simple) where

import qualified Data.ByteString.Lazy as BL
import           Data.Csv             (HasHeader (HasHeader), decode, encode)
import qualified Data.Vector          as V

type Rows = V.Vector SingleRow
type SingleRow = (Int, String)

simple :: IO ()
simple = do
  csvData <- BL.readFile "tmp/large.csv"
  case decode HasHeader csvData of
    Left err   -> putStrLn err
    Right rows -> handleRight rows

handleRight :: Rows -> IO ()
handleRight rows = printAndWrite $ correctRows rows

correctRows :: Rows -> Rows
correctRows rows = V.filter filterer rows

filterer :: SingleRow -> Bool
filterer (rowID, _) = filterFunc rowID

filterFunc :: Int -> Bool
filterFunc i = mod i 7 == 0

printAndWrite :: Rows -> IO ()
printAndWrite rows = printAction *> writeAction where
  printAction = print stringified
  writeAction = write stringified
  stringified = encode $ V.toList rows

write :: BL.ByteString -> IO ()
write string = BL.writeFile "tmp/parsed.csv" string
