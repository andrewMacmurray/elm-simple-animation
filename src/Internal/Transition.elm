module Internal.Transition exposing
    ( Config
    , Option(..)
    , Property(..)
    , ToProperty
    , Transition(..)
    , all
    , properties
    , render
    , toAttr
    )

import Html exposing (Attribute)
import Html.Attributes
import Internal.Ease as Ease exposing (Ease)
import Internal.Unit as Unit exposing (Millis)



-- Transition


type Transition
    = Transition (List Property)


type Option
    = Delay Millis
    | Ease Ease


type Property
    = Property String Millis (List Option)


type alias Config =
    { duration : Millis
    , options : List Option
    }


type alias ToProperty =
    Millis -> List Option -> Property



-- All


all : Config -> List ToProperty -> Transition
all config =
    List.map (\p -> p config.duration config.options) >> Transition



-- Properties


properties : List Property -> Transition
properties =
    Transition



-- Render


render : Transition -> String
render (Transition props) =
    List.map renderProperty props |> intersperseValuesWith ", "


renderProperty : Property -> String
renderProperty (Property name duration options) =
    intersperseValuesWith " "
        [ name
        , Unit.ms duration
        , findEaseOption options |> renderOptionShorthand
        , findDelayOption options |> renderOptionShorthand
        ]


renderOptionShorthand : Option -> String
renderOptionShorthand o =
    case o of
        Delay n ->
            Unit.ms n

        Ease e ->
            Ease.toString e


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
        (Ease Ease.Ease)


intersperseValuesWith : String -> List String -> String
intersperseValuesWith separator =
    List.intersperse separator >> String.concat


toAttr : Transition -> Attribute msg
toAttr =
    render >> Html.Attributes.style "transition"
