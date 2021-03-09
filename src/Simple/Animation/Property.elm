module Simple.Animation.Property exposing
    ( Property
    , opacity
    , rotate, scale, scaleXY, y, x, xy
    , color, backgroundColor, borderColor
    , property
    )

{-| Animatable properties


# Property

@docs Property


# Common Properties

These properties will give you smooth and performant animations


## Opacity

Animate the opacity of an element (a value between `0` and `1`)

@docs opacity


## Transforms

Move, Rotate and resize elements

@docs rotate, scale, scaleXY, y, x, xy


## Colors

@docs color, backgroundColor, borderColor


# Custom Property

Animate any CSS property:

    P.property "stroke-dasharray" "10"

Take care with properties that are not hardware accelerated as they may result in janky animations

@docs property

-}

import Internal.Animation.Property as Internal exposing (..)
import Internal.Transform as Transform


{-| -}
type alias Property =
    Internal.Property


{-| -}
opacity : Float -> Property
opacity =
    Opacity


{-| -}
y : Float -> Property
y =
    Transform << Transform.y


{-| -}
x : Float -> Property
x =
    Transform << Transform.x


{-| -}
xy : Float -> Float -> Property
xy x_ y_ =
    Transform (Transform.xy x_ y_)


{-| -}
scale : Float -> Property
scale n =
    Transform (Transform.scaleXY n n)


{-| -}
scaleXY : Float -> Float -> Property
scaleXY x_ y_ =
    Transform (Transform.scaleXY x_ y_)


{-| -}
rotate : Float -> Property
rotate =
    Transform << Transform.rotate


{-| -}
color : String -> Property
color =
    property "color"


{-| -}
backgroundColor : String -> Property
backgroundColor =
    property "background-color"


{-| -}
borderColor : String -> Property
borderColor =
    property "border-color"


{-| -}
property : String -> String -> Property
property =
    Raw
