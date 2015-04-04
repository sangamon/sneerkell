module Sneer.ClientSpec where

import Control.Concurrent.Async
import Sneer.Client
import Sneer.Transit
import System.Timeout
import Test.Hspec

spec :: Spec
spec =
  describe "client" $
    it "can exchange messages with server" $ do
      subject <- newClient
      pendingAck <- async $ receiveFrom subject
      sendTo subject $ Map [(k "send", tuple)
                           ,(k "from", k "me")
                           ,(k "to",   k "you")
                           ]
      Just _ <- timeoutIn 5 seconds $ wait pendingAck
      return ()
 where
  tuple = Map [("id", Number 42)]
  k = Keyword

timeoutIn :: Int -> (Int -> Int) -> IO a -> IO (Maybe a)
timeoutIn t unit = timeout (unit t)

seconds :: Int -> Int
seconds = (* 1000000)
