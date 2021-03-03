module Simple.Transition exposing
    ( Property
    , Transition
    , all
    , backgroundColor
    , borderColor
    , color
    , cubic
    , delay
    , easeIn
    , easeInOut
    , easeOut
    , linear
    , opacity
    , properties
    , transform
    )

import Html
import Internal.Animation exposing (Millis)
import Internal.Ease as Ease
import Internal.Transition as Internal exposing (..)


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


delay : Millis -> Option
delay =
    Delay


{-| -}
linear : Option
linear =
    Ease Ease.Linear


{-| -}
easeIn : Option
easeIn =
    Ease Ease.EaseIn


{-| -}
easeOut : Option
easeOut =
    Ease Ease.EaseOut


{-| -}
easeInOut : Option
easeInOut =
    Ease Ease.EaseInOut


{-| -}
cubic : Float -> Float -> Float -> Float -> Option
cubic a b c d =
    Ease (Ease.Cubic a b c d)
