module Main
  ( main
  ) where

import Chat.Discord (clientChannels, clientLogin, newClient)
import Node.Process (lookupEnv)
import Stuff

main :: IOSync Unit
main = launchIO do
  client <- newClient

  token <- liftEff $ fromMaybe "" <$> lookupEnv "DUNGEOFF_DISCORD_TOKEN"
  actualToken <- clientLogin client token
  traceAnyA actualToken

  channels <- clientChannels client
  traceAnyA channels

  pure unit
