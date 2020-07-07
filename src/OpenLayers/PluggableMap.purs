-- |
-- | The OpenLayers PluggableMap module, a purescript FFI mapping. It also
-- | reexports functions based on the `PluggableMap` inheritance structure.
-- |
-- | All functions and types of the OpenLayer API are currently not mapped.
-- |
-- | Functions, types or constants not part of the OpenLayers API or have
-- | a different semantics are documented in this module, otherwise they
-- | are documented in the OpenLayers API documentation.
-- |
-- | https://openlayers.org/en/latest/apidoc/
module OpenLayers.PluggableMap (
  PluggableMap
  , RawPluggableMap

  , addLayer
  , addInteraction

  , getView

  , setTarget
  , clearTarget

  ) where

-- Standard import
import Prelude

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

-- Openlayers
import OpenLayers.FFI as FFI
import OpenLayers.View as View
import OpenLayers.Layer.Base as Base
import OpenLayers.Interaction.Interaction as Interaction

--
-- Foreign data types
--

-- |The FFI version of the Map. For internal use only!
foreign import data RawPluggableMap :: Type->Type
type PluggableMap a = RawPluggableMap a
--
-- Function mapping
--

--
-- add functions
--
foreign import addLayerImpl :: forall l m . Fn2 (Base.BaseLayer l) (PluggableMap m) (Effect Unit)

addLayer :: forall l m . Base.BaseLayer l -> PluggableMap m -> Effect Unit
addLayer o = runFn2 addLayerImpl o

foreign import addInteractionImpl :: forall i m . Fn2 (Interaction.Interaction i) (PluggableMap m) (Effect Unit)

addInteraction :: forall i m . Interaction.Interaction i -> PluggableMap m -> Effect Unit
addInteraction i = runFn2 addInteractionImpl i

--
-- get functions
--
foreign import getViewImpl :: forall m . Fn1 (PluggableMap m) (Effect (Nullable View.View))

getView :: forall m . PluggableMap m -> Effect (Maybe View.View)
getView o = toMaybe <$> runFn1 getViewImpl o

--
-- set function
--

foreign import setTargetImpl :: forall m . Fn2 (FFI.NullableOrUndefined String) (PluggableMap m) (Effect Unit)

-- |Sets the rendering target of the `PluggableMap`, the function is currently only implemented for
-- |the id of the HTML element and a `clearTarget` to remove it. See `setTarget` in the OpenLayers API documentation.
setTarget::forall m . Maybe String -> PluggableMap m -> Effect Unit
setTarget s self = runFn2 setTargetImpl (FFI.toNullable s) self

-- |Clears the current target, see `setTarget` of the `PluggableMap` in the OpenLayers API documentation.
clearTarget::forall m . PluggableMap m -> Effect Unit
clearTarget self = runFn2 setTargetImpl FFI.undefined self
