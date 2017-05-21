module Chat.Discord
  ( DISCORD

  , Snowflake

  , Client
  , newClient
  , clientLogin
  , clientChannels

  , Channel

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

--------------------------------------------------------------------------------

foreign import data Channel :: Type

--------------------------------------------------------------------------------

foreign import data Collection :: Type -> Type -> Type

collectionGet :: ∀ eff f k v. MonadEff (discord :: DISCORD | eff) f =>
  Collection k v -> k -> f (Maybe v)
collectionGet = (liftEff <<< _) <<< ffiCollectionGet Nothing Just

foreign import ffiCollectionGet :: ∀ k v eff. (∀ a. Maybe a) ->
  (∀ a. a -> Maybe a) -> Collection k v -> k ->
  Eff (discord :: DISCORD | eff) (Maybe v)
