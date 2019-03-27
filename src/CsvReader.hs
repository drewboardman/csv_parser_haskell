{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}

module CsvReader (test) where

import qualified Data.ByteString.Lazy as BL
import           Data.Csv
import qualified Data.Vector          as V

data Row = Row
  { sectionName :: !String
  , menuName    :: !String
  , channelID   :: !Int
  , userName    :: !String
  }

instance FromNamedRecord Row where
  parseNamedRecord namedR = Row
    <$> namedR .: "Section Name"
      <*> namedR .: "Menu Name"
      <*> namedR .: "Channel ID"
      <*> namedR .: "Editor (User Name)"

test :: IO ()
test = do
  csvData <- BL.readFile "tmp/robots.csv"
  case decodeByName csvData of
    Left err -> putStrLn err
    Right (_, vecRow) -> V.forM_ vecRow (\ row ->
      putStrLn $ sectionName row ++ menuName row ++ show (channelID row) ++ userName row)
