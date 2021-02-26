module Internal.Transition exposing
    ( Config
    , Property(..)
    , PropertyShorthand
    , Transition(..)
    , all
    , render
    , toAttr
    )

import Html exposing (Attribute)
import Html.Attributes
import Internal.Animation
    exposing
        ( Millis
        , Option
        , findDelayOption
        , findEaseOption
        , ms
        , renderOptionShorthand
        )


type Transition
    = Transition (List Property)


type Property
    = Property String Millis (List Option)


type alias Config =
    { duration : Millis, options : List Option }


type alias PropertyShorthand =
    Millis -> List Option -> Property


all : Config -> List PropertyShorthand -> Transition
all config =
    List.map (\p -> p config.duration config.options)
        >> Transition


render : Transition -> String
render (Transition props) =
    List.map renderProperty props
        |> intersperseValuesWith ", "


renderProperty : Property -> String
renderProperty (Property name duration options) =
    intersperseValuesWith " "
        [ name
        , ms duration
        , findEaseOption options |> renderOptionShorthand
        , findDelayOption options |> renderOptionShorthand
        ]


intersperseValuesWith : String -> List String -> String
intersperseValuesWith separator =
    List.intersperse separator >> List.foldr (++) ""


toAttr : Transition -> Attribute msg
toAttr =
    render >> Html.Attributes.style "transition"
