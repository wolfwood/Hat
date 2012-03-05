module PackedString (PackedString, unpackPS, packString) where

import Data.ByteString

import Codec.Binary.UTF8.String

type PackedString = ByteString

--import Data.ByteString pack as packString
--import Data.ByteString.unpack as unpackPS



packString :: String -> ByteString
packString s = pack $ encode s

unpackPS   :: ByteString -> String
unpackPS ps = decode $ unpack ps
