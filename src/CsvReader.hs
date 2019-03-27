{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE TypeFamilies #-}

module CsvReader (test) where

import Data.Functor.Identity (Identity)
import qualified Data.ByteString.Lazy as BL
import           Data.Csv
import qualified Data.Vector          as V

type family HKD f a where
  HKD Identity a = a
  HKD f a        = f a

data Row f = Row
  { sectionName :: HKD f String
  , menuName    :: HKD f String
  , channelID   :: HKD f Int
  , userName    :: HKD f String
  }

type RegularRow = Row Identity
type MaybeRow = Row Maybe

instance FromNamedRecord (Row a) where
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
    Right (_, vecRow) -> V.forM_ vecRow $ filterAndPrint . validate

filterAndPrint :: MaybeRow -> IO ()
filterAndPrint mRow = do
  sName <- sectionName mRow
  mName <- menuName mRow
  uName <- userName mRow
  case (channelID mRow) of
    Just channel -> (putStrLn $ sName ++ mName ++ show (channel) ++ uName)
    Nothing -> ()

isGoodChannel :: Int -> Maybe Int
isGoodChannel c = if c > 5 then Just c else Nothing

validate :: RegularRow -> MaybeRow
validate (Row sName mName cID uName) = myRow where
  mChannelID = isGoodChannel cID
  myRow = Row (Just sName) (Just mName) mChannelID (Just uName)
