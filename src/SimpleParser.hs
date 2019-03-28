{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}

module SimpleParser (simple) where

import qualified Data.ByteString.Lazy  as BL
import           Data.Csv
import           Data.Functor.Identity (Identity)
-- import           Control.Monad.Extra
import qualified Data.Vector           as V

simple :: IO ()
simple = do
  csvData <- BL.readFile "tmp/users.csv"
  case decode HasHeader csvData of
    Left err -> putStrLn err
    Right vec -> V.forM_ vec (\(userCode :: Int, groupCode :: Int) ->
      putStrLn $ show userCode ++ show groupCode)

-- rowToPrint :: (Int, Int) -> IO (BL.ByteString)
-- rowToPrint (userCode :: Int, groupCode :: Int) =
--   putStrLn BL.pack userCode ++ BL.pack groupCode
