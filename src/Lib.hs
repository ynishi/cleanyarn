module Lib
  ( clean
  ) where

import           Control.Monad
import           Data.Fixed       (Pico)
import           Data.Time.Clock
import           System.Directory

clean :: IO ()
clean = do
  n <- getCurrentTime
  print n
  cleanNodeModule
  cleanYarnlock
  where
    cleanYarnlock = cleanInner "yarn.lock" doesFileExist removeFile
    cleanNodeModule =
      cleanInner "node_modules" doesDirectoryExist removeDirectoryRecursive

cleanInner p e f = do
  b <- e p
  when b $ putStrLn $ "found: " ++ p
  t <- getModificationTime p
  putStrLn $ "modified at: " ++ show t
  n <- getCurrentTime
  let isModifiedIn30Sec = diffUTCTime n t < (30 :: NominalDiffTime)
  when isModifiedIn30Sec $ do
    f p
    putStrLn $ "removed: " ++ p
