module Simple.Animation.Property exposing
    ( Property
    , opacity, rotate, scale, scaleXY, y, x
    , property
    , xy
    )

{-|


# Property

@docs Property


# Common Properties

@docs opacity, rotate, scale, scaleXY, y, x


# Custom Property

@docs property

-}

import Internal.Property as Internal


{-| -}
type alias Property =
    Internal.Property


{-| -}
opacity : Float -> Property
opacity =
    Internal.opacity


{-| -}
rotate : Float -> Property
rotate =
    Internal.rotate


{-| -}
scale : Float -> Property
scale =
    Internal.scale


{-| -}
scaleXY : Float -> Float -> Property
scaleXY =
    Internal.scaleXY


{-| -}
x : Float -> Property
x =
    Internal.x


{-| -}
y : Float -> Property
y =
    Internal.y


xy : Float -> Float -> Property
xy =
    Internal.xy


{-| -}
property : String -> String -> Property
property =
    Internal.property
