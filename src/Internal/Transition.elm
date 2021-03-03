module Internal.Transition exposing
    ( Config
    , Option(..)
    , Property(..)
    , PropertyShorthand
    , Transition(..)
    , all
    , properties
    , render
    , toAttr
    )

import Html exposing (Attribute)
import Html.Attributes
import Internal.Animation exposing (Millis, ms)
import Internal.Ease as Ease exposing (Ease)


type Transition
    = Transition (List Property)


type Option
    = Delay Millis
    | Ease Ease


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


properties : List Property -> Transition
properties =
    Transition


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


renderOptionShorthand : Option -> String
renderOptionShorthand o =
    case o of
        Delay n ->
            ms n

        Ease e ->
            Ease.render e


findDelayOption : List Option -> Option
findDelayOption =
    List.foldl
        (\o acc ->
            case o of
                Delay _ ->
                    o

                _ ->
                    acc
        )
        (Delay 0)


findEaseOption : List Option -> Option
findEaseOption =
    List.foldl
        (\o acc ->
            case o of
                Ease _ ->
                    o

                _ ->
                    acc
        )
        (Ease Ease.Default)


intersperseValuesWith : String -> List String -> String
intersperseValuesWith separator =
    List.intersperse separator >> List.foldr (++) ""


toAttr : Transition -> Attribute msg
toAttr =
    render >> Html.Attributes.style "transition"
