{-# LANGUAGE NumericUnderscores #-}
{-# LANGUAGE OverloadedStrings #-}

module Maker (writeRows) where

import qualified Data.ByteString.Lazy as BL
import           Data.Csv             (encode)

writeRows :: IO ()
writeRows = write $ encode createRows

write :: BL.ByteString -> IO ()
write string = BL.writeFile "tmp/large.csv" string

createRows :: [(Int, String)]
createRows = [(x, addName x) | x <- [0..100_000] ]

addName :: Int -> String
addName x = "name" <> show x
