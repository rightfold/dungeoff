module Main
  ( main
  ) where

import Chat.Discord as D
import Node.Process (lookupEnv)
import Stuff

main :: IOSync Unit
main = launchIO do
  client <- D.newClient

  token <- liftEff $ fromMaybe "" <$> lookupEnv "DUNGEOFF_DISCORD_TOKEN"
  actualToken <- D.clientLogin client token
  traceAnyA actualToken

  channels <- D.clientChannels client
  traceAnyA channels

  D.clientOnMessage client \message -> do
    content <- D.messageContent message
    traceAnyA content

  pure unit
