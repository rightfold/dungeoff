module Main
  ( main
  ) where

import Chat.Discord as D
import Data.String as String
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

  D.clientOnMessage client \message -> runIOSync' \ launchIO $ do
    author <- D.messageAuthor message
    bot <- D.userBot author
    when (not bot) do
      content <- D.messageContent message
      traceAnyA content

      D.messageReply message (String.toUpper content)

  pure unit
