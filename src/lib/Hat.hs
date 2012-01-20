module Hat
  (
  ) where


class Wrap r t | r->t, t->r where
  unwrap  :: (RefExp -> R a -> b) -> RefExp -> R (r a) -> t b
  wrap    :: (RefExp -> a -> R b) -> RefExp -> t a     -> R (r a)

  extract :: r a     -> t (R a)
  embed   :: t (R a) -> r a
  refatom :: t a     -> RefAtom

  unwrap f h (R value _) = fakemap (f h) (extract value)
  wrap   f h value       = R (embed (fakemap (f h) value))
                             (T.mkValueUse h mkNoSrcPos (refatom value))


newtype Hat.IORef a = IORef (IORef (R a))
instance Wrap Hat.IORef IORef where
  extract (IORef ref) = ref
  embed   ref         = IORef ref
  refatom _           = mkAbstract "IORef"

