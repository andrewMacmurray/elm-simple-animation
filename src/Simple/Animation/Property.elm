module Simple.Animation.Property exposing
    ( Property
    , opacity
    , property
    , rotate
    , scale
    , scaleXY
    , x
    , y
    )

import Internal.Property as Internal


type alias Property =
    Internal.Property


opacity : Float -> Property
opacity =
    Internal.opacity


property : String -> String -> Property
property =
    Internal.property


rotate : Float -> Property
rotate =
    Internal.rotate


scale : Float -> Property
scale =
    Internal.scale


scaleXY : Float -> Float -> Property
scaleXY =
    Internal.scaleXY


x : Float -> Property
x =
    Internal.x


y =
    Internal.y
