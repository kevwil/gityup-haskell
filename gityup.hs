-- copyright goes here
--
module Main where

import System.Environment (getArgs)
import System.Directory-- (doesDirectoryExist,getDirectoryContents)
import Control.Monad (filterM)
import System.Exit
import System.Process (createProcess,proc)

main :: IO ()
main = do
  [basedir] <- getArgs
  dirTest <- doesDirectoryExist basedir
  if dirTest
    then do
      subdirs <- getDirectoryContents basedir
      workspaces <- filterM hasMeta ( fullPaths basedir subdirs )
      mapM_ runUpdate workspaces
      exitSuccess
    else
      putStrLn "not a directory"

fullPaths :: FilePath -> [FilePath] -> [FilePath]
-- fullPaths basepath paths =
  -- map (\x -> (basepath ++ "/" ++ x)) paths
fullPaths basepath =
  map (\x -> basepath ++ "/" ++ x)

hasMeta :: FilePath -> IO Bool
hasMeta (someDir ) =
  doesDirectoryExist( someDir ++ "/.git" )

runUpdate :: FilePath -> IO Bool
runUpdate targetDir = do
  setCurrentDirectory targetDir
  putStrLn ("#### updating " ++ targetDir ++ " ####")
  createProcess (proc "git" ["smart-pull"])
  return True
