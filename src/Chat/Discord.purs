module Chat.Discord
  ( DISCORD

  , Snowflake

  , Client
  , newClient
  , clientLogin
  , clientChannels
  , clientOnMessage

  , Channel

  , User
  , userBot

  , Message
  , messageContent
  , messageAuthor
  , messageReply

  , Collection
  , collectionGet
  ) where

import Control.Monad.Aff (makeAff)
import Control.Monad.Aff.Class (class MonadAff, liftAff)
import Control.Monad.Eff (kind Effect, Eff)
import Control.Monad.Eff.Class (class MonadEff, liftEff)
import Control.Monad.Eff.Exception (Error)
import Data.Maybe (Maybe(..))
import Prelude

--------------------------------------------------------------------------------

foreign import data DISCORD :: Effect

--------------------------------------------------------------------------------

foreign import data Snowflake :: Type

--------------------------------------------------------------------------------

foreign import data Client :: Type

newClient :: ∀ eff f. MonadEff (discord :: DISCORD | eff) f => f Client
newClient = liftEff ffiNewClient

foreign import ffiNewClient :: ∀ eff. Eff (discord :: DISCORD | eff) Client

clientLogin :: ∀ eff f. MonadAff (discord :: DISCORD | eff) f => Client ->
  String -> f String
clientLogin = ((liftAff <<< makeAff) <<< _) <<< ffiClientLogin

foreign import ffiClientLogin :: ∀ eff. Client -> String ->
  (Error -> Eff (discord :: DISCORD | eff) Unit) ->
  (String -> Eff (discord :: DISCORD | eff) Unit) ->
  Eff (discord :: DISCORD | eff) Unit

clientChannels :: ∀ eff f. MonadEff (discord :: DISCORD | eff) f => Client ->
  f (Collection Snowflake Channel)
clientChannels = liftEff <<< ffiClientChannels

foreign import ffiClientChannels :: ∀ eff. Client ->
  Eff (discord :: DISCORD | eff) (Collection Snowflake Channel)

clientOnMessage :: ∀ eff f. MonadEff (discord :: DISCORD | eff) f => Client ->
  (Message -> Eff (discord :: DISCORD | eff) Unit) -> f Unit
clientOnMessage = (liftEff <<< _) <<< ffiClientOnMessage

foreign import ffiClientOnMessage :: ∀ eff. Client ->
  (Message -> Eff (discord :: DISCORD | eff) Unit) ->
  Eff (discord :: DISCORD | eff) Unit

--------------------------------------------------------------------------------

foreign import data Channel :: Type

--------------------------------------------------------------------------------

foreign import data User :: Type

userBot :: ∀ eff f. MonadEff (discord :: DISCORD | eff) f => User -> f Boolean
userBot = liftEff <<< ffiUserBot

foreign import ffiUserBot :: ∀ eff. User ->
  Eff (discord :: DISCORD | eff) Boolean

--------------------------------------------------------------------------------

foreign import data Message :: Type

messageContent :: ∀ eff f. MonadEff (discord :: DISCORD | eff) f => Message ->
  f String
messageContent = liftEff <<< ffiMessageContent

foreign import ffiMessageContent :: ∀ eff. Message ->
  Eff (discord :: DISCORD | eff) String

messageAuthor :: ∀ eff f. MonadEff (discord :: DISCORD | eff) f => Message ->
  f User
messageAuthor = liftEff <<< ffiMessageAuthor

foreign import ffiMessageAuthor :: ∀ eff. Message ->
  Eff (discord :: DISCORD | eff) User

messageReply :: ∀ eff f. MonadAff (discord :: DISCORD | eff) f => Message ->
  String -> f Unit
messageReply = ((liftAff <<< makeAff) <<< _) <<< ffiMessageReply

foreign import ffiMessageReply :: ∀ eff. Message -> String ->
  (Error -> Eff (discord :: DISCORD | eff) Unit) ->
  (Unit -> Eff (discord :: DISCORD | eff) Unit) ->
  Eff (discord :: DISCORD | eff) Unit

--------------------------------------------------------------------------------

foreign import data Collection :: Type -> Type -> Type

collectionGet :: ∀ eff f k v. MonadEff (discord :: DISCORD | eff) f =>
  Collection k v -> k -> f (Maybe v)
collectionGet = (liftEff <<< _) <<< ffiCollectionGet Nothing Just

foreign import ffiCollectionGet :: ∀ k v eff. (∀ a. Maybe a) ->
  (∀ a. a -> Maybe a) -> Collection k v -> k ->
  Eff (discord :: DISCORD | eff) (Maybe v)
