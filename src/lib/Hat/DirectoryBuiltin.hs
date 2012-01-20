module Hat.DirectoryBuiltin where

import Hat.Hat as T
import Hat.PreludeBuiltinTypes
import Hat.DirectoryBuiltinTypes
import qualified Directory

toPermissions :: RefExp -> R Permissions -> Directory.Permissions
toPermissions h 
  (R (Permissions preadable pwritable pexecutable psearchable) _) =
    Directory.Permissions (toBool h preadable) (toBool h pwritable)
      (toBool h pexecutable) (toBool h psearchable)

fromPermissions :: RefExp -> Directory.Permissions -> R Permissions
fromPermissions h 
  (Directory.Permissions preadable pwritable pexecutable psearchable) =
    con4 mkNoSrcPos h Permissions aPermissions 
      (T.wrapForward h (fromBool h preadable)) 
      (T.wrapForward h (fromBool h pwritable))
      (T.wrapForward h (fromBool h pexecutable)) 
      (T.wrapForward h (fromBool h psearchable))
