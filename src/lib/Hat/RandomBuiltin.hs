module Hat.RandomBuiltin(StdGen,module Hat.RandomBuiltin) where

import Hat.Hat as T
import Random

toStdGen :: RefExp -> R StdGen -> Random.StdGen
toStdGen h (R v _) = v

fromStdGen :: RefExp -> Random.StdGen -> R StdGen
fromStdGen h v = R v (T.mkValueUse h mkNoSrcPos aStdGen)

aStdGen :: RefAtom
aStdGen = mkAbstract "StdGen"

