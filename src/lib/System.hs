module System ( 
     ExitCode(ExitSuccess,ExitFailure),
     getArgs, getProgName, getEnv, system, exitWith, exitFailure
   ) where

import PreludeBuiltinTypes
import SystemBuiltinTypes
import SystemBuiltin
import qualified TraceOrigSystem

foreign import haskell "System.getArgs"
 getArgs :: IO [String]
foreign import haskell "System.getProgName"
 getProgName :: IO String
foreign import haskell "System.getEnv"
 getEnv :: String -> IO String
foreign import haskell "System.system"
 system :: String -> IO ExitCode
foreign import haskell "System.exitWith"
 exitWith :: ExitCode -> IO a
foreign import haskell "System.exitFailure"
 exitFailure :: IO a