module Hat.SystemBuiltin where

import Hat.Hat as T
import Hat.SystemBuiltinTypes
import Hat.PreludeBuiltinTypes
import qualified System

toExitCode :: RefExp -> R ExitCode -> System.ExitCode
toExitCode h (R ExitSuccess _) = System.ExitSuccess
toExitCode h (R (ExitFailure rnum) _) = System.ExitFailure (toInt h rnum)

fromExitCode :: RefExp -> System.ExitCode -> R ExitCode
fromExitCode h System.ExitSuccess = 
  T.con0 mkNoSrcPos h ExitSuccess aExitSuccess
fromExitCode h (System.ExitFailure num) =
  T.con1 mkNoSrcPos h ExitFailure aExitFailure 
    (T.wrapForward h (fromInt h num))
