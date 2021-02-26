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

import Html
import Internal.Transition as Internal exposing (Config, PropertyShorthand)


type alias Transition =
    Internal.Transition


type alias Property =
    Internal.Property


all : Config -> List PropertyShorthand -> Html.Attribute msg
all config props =
    Internal.all config props
        |> Internal.toAttr


properties : List Property -> Html.Attribute msg
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
