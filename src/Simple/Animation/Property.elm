module Simple.Animation.Property exposing
    ( Property
    , opacity
    , rotate, scale, scaleXY, y, x, xy
    , color, backgroundColor, borderColor
    , property
    )

{-| Animatable `Properties` specify what your animation should look like at each point in an animation.

@docs Property


# Common Properties

These properties will give you smooth and performant animations.

@docs opacity


## Transforms

Move, Rotate and resize elements.

@docs rotate, scale, scaleXY, y, x, xy


## Colors

@docs color, backgroundColor, borderColor


# Custom Property

Animate any CSS property:

    P.property "stroke-dasharray" "10"

Take care with properties that are not hardware accelerated as they may result in janky animations.

@docs property

-}

import Internal.Animation.Property as Internal
import Internal.Transform as Transform


{-| An animatable property.
-}
type alias Property =
    Internal.Property


{-| Animate the opacity of an element (a value between `0` and `1`).
-}
opacity : Float -> Property
opacity =
    Internal.Opacity


{-| -}
y : Float -> Property
y =
    Internal.Transform << Transform.y


{-| -}
x : Float -> Property
x =
    Internal.Transform << Transform.x


{-| -}
xy : Float -> Float -> Property
xy x_ y_ =
    Internal.Transform (Transform.xy x_ y_)


{-| -}
scale : Float -> Property
scale n =
    Internal.Transform (Transform.scaleXY n n)


{-| -}
scaleXY : Float -> Float -> Property
scaleXY x_ y_ =
    Internal.Transform (Transform.scaleXY x_ y_)


{-| -}
rotate : Float -> Property
rotate =
    Internal.Transform << Transform.rotate


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
    Internal.Raw
