-- |
-- | The OpenLayers Vector module, a purescript FFI mapping. It also
-- | reexports functions based on the `Vector` inheritance structure.
-- |
-- | All functions and types of the OpenLayer API are currently not mapped.
-- |
-- | Functions, types or constants not part of the OpenLayers API or have
-- | a different semantics are documented in this module, otherwise they
-- | are documented in the OpenLayers API documentation.
-- |
-- | https://openlayers.org/en/latest/apidoc/
module OpenLayers.Layer.Vector (
  module BaseVector

  , Vector
  , Style(..)
  , RawVector
  , Options(..)

  , create
  , create'
  
  , setStyle ) where

-- Standard import
import Prelude
import Prim.Row (class Union)

-- Data imports
import Data.Nullable (Nullable, toNullable)
import Data.Maybe (Maybe)
import Data.Function.Uncurried
  ( Fn1
  , Fn2
  , runFn1
  , runFn2)

-- Effect imports
import Effect (Effect)

-- Our own imports
import OpenLayers.Layer.BaseVector (BaseLayer, BaseVectorLayer, Layer, RawBaseLayer, RawBaseVectorLayer, RawLayer, setSource, getSource) as BaseVector
import OpenLayers.Source.Vector as Vector
import OpenLayers.Style.Style as Style
import OpenLayers.Feature as Feature
import OpenLayers.FFI as FFI

--
-- Our own data types
--

-- |The `Style` used by the `Vector` layer to determine how to render a `Feature`
-- |if it does not have a style.
-- |
-- | `Style style` is a style for all features.
-- |
-- | `StyleFunction fn` is a function that returns a style for a specific feature.
-- |
-- | `StyleArray style` is an array of styles for all features.
data Style =  Style Style.Style
            | StyleFunction (Feature.Feature->Number->Effect (Maybe Style.Style))
            | StyleArray (Array Style.Style)
--
-- Foreign data types
-- 
foreign import data RawVector :: Type
type Vector = BaseVector.BaseVectorLayer RawVector

--
-- Function mapping
--
foreign import createImpl :: forall r . Fn1 (FFI.NullableOrUndefined (Record r)) (Effect Vector)

-- |The options for the creation of the Vector. See the `options` parameter in `new Vector(options)` in the OpenLayers API documentation.
type Options = ( source :: Vector.VectorSource )

-- |Creates a new `Tile`, see `new Tile(r)` in the OpenLayers API documentation.
create :: forall l r . Union l r Options => Record l -> Effect Vector
create o = runFn1 createImpl (FFI.notNullOrUndefined o)

-- |Creates a new `Tile` with defaults, see `new Tile()` in the OpenLayers API documentation.
create' :: Effect Vector
create' = runFn1 createImpl FFI.undefined

--
-- Setters
--
foreign import setStyleImpl :: Fn2 Style.Style Vector (Effect Unit)
foreign import setStyleFImpl :: Fn2 (Feature.Feature->Number->Effect (Nullable Style.Style)) Vector (Effect Unit)
foreign import setStyleAImpl :: Fn2 (Array Style.Style) Vector (Effect Unit)

setStyle::Style->Vector->Effect Unit
setStyle (Style s) self = runFn2 setStyleImpl s self
setStyle (StyleFunction f) self = runFn2 setStyleFImpl (toStyleFunction f) self
  where
    -- Convert it from a Maybe to a Nullable Style for this so we do not expose Nullabe
    toStyleFunction::(Feature.Feature->Number->Effect (Maybe Style.Style))->Feature.Feature->Number->Effect (Nullable Style.Style)
    toStyleFunction ff feature n = toNullable <$> (ff feature n)
setStyle (StyleArray a) self = runFn2 setStyleAImpl a self