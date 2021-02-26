module Simple.Transition exposing
    ( Property
    , Transition
    , all
    , backgroundColor
    , borderColor
    , color
    , opacity
    , properties
    , transform
    )

import Internal.Animation exposing (Millis, Option)
import Internal.Transition as Internal


type alias Transition =
    Internal.Transition


type alias Property =
    Internal.Property


type alias Config =
    { duration : Millis, options : List Option }


type alias PropertyShorthand =
    Millis -> List Option -> Property


all : Config -> List PropertyShorthand -> Transition
all config =
    List.map (\p -> p config.duration config.options)
        >> Internal.Transition
        >> Internal.toAttr


properties : List Property -> Transition
properties =
    Internal.Transition
        >> Internal.toAttr


transform : PropertyShorthand
transform =
    Internal.Property "transform"


opacity : PropertyShorthand
opacity =
    Internal.Property "opacity"


color : PropertyShorthand
color =
    Internal.Property "color"


backgroundColor : PropertyShorthand
backgroundColor =
    Internal.Property "background-color"


borderColor : PropertyShorthand
borderColor =
    Internal.Property "border-color"
