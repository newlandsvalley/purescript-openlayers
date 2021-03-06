-- |
-- | The OpenLayers View module, a purescript FFI mapping. It also
-- | reexports functions based on the `View` inheritance structure.
-- |
-- | All functions and types of the OpenLayer API are currently not mapped.
-- |
-- | Functions, types or constants not part of the OpenLayers API or have
-- | a different semantics are documented in this module, otherwise they
-- | are documented in the OpenLayers API documentation.
-- |
-- | https://openlayers.org/en/latest/apidoc/
module OpenLayers.View (
  View
  , Options(..)

  , create
  , create'

  , setCenter
  , getCenter
  , setZoom
  , getZoom
  , getResolution

  , getProjection) where

-- Standard import
import Prelude
import Prim.Row (class Union)

-- Data imports
import Data.Nullable (Nullable, toMaybe)
import Data.Maybe (Maybe)
import Data.Function.Uncurried
  ( Fn1
  , Fn2
  , runFn1
  , runFn2)

-- Effect imports
import Effect (Effect)

-- Our own imports
import OpenLayers.FFI as FFI
import OpenLayers.Proj as Proj
import OpenLayers.Coordinate as Coordinate

--
-- Foreign data types
-- 

foreign import data View :: Type

-- |The options for the creation of the View. See the `options` parameter in `new View(options)` in the OpenLayers API documentation.
type Options = (projection :: Proj.SRS, center :: Array Number, zoom :: Number)

--
-- Function mapping
--
foreign import createImpl :: forall r . Fn1 (FFI.NullableOrUndefined (Record r)) (Effect View)

-- |Creates a `View`, see `new View(r)` in the OpenLayers API documentation.
create :: forall l r . Union l r Options => Record l -> Effect View
create o = runFn1 createImpl (FFI.notNullOrUndefined o)

-- |Creates a `View` with defaults, see `new View(r)` in the OpenLayers API documentation.
create' :: Effect View
create' = runFn1 createImpl FFI.undefined

--
-- set functions
--
foreign import setCenterImpl :: Fn2(Array Number) View (Effect Unit)

setCenter :: Coordinate.Coordinate -> View -> Effect Unit
setCenter pos self = runFn2 setCenterImpl pos self

foreign import setZoomImpl :: Fn2 Number View (Effect Unit)

setZoom :: Number -> View -> Effect Unit
setZoom z self = runFn2 setZoomImpl z self

--
-- get functins
--
foreign import getProjectionImpl :: Fn1 View (Effect (Nullable String))

getProjection :: View -> Effect (Maybe String)
getProjection self = toMaybe <$> runFn1 getProjectionImpl self

foreign import getResolutionImpl :: Fn1 View (Effect (FFI.NullableOrUndefined Number))

getResolution :: View -> Effect (Maybe Number)
getResolution self = FFI.toMaybe <$> runFn1 getResolutionImpl self

foreign import getCenterImpl :: Fn1 View (Effect (FFI.NullableOrUndefined Coordinate.Coordinate))

getCenter :: View -> Effect (Maybe Coordinate.Coordinate)
getCenter self = FFI.toMaybe <$> runFn1 getCenterImpl self

foreign import getZoomImpl :: Fn1 View (Effect (FFI.NullableOrUndefined Number))

getZoom :: View -> Effect (Maybe Number)
getZoom self = FFI.toMaybe <$> runFn1 getZoomImpl self
