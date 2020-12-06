module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Events exposing (onClick)
import Element.Font as Font
import Examples.FromTo as FromTo
import Examples.Renderers as Renderers
import Examples.Sequence as Sequence
import Examples.Steps as Steps
import Html exposing (Html)
import Utils.UI exposing (black, blue, medium)



-- Main


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



-- Model


type alias Model =
    { example : Example
    }


type Example
    = FromTo
    | Steps
    | Sequence
    | Renderers


type Msg
    = ExampleSelected Example



-- Init


init : Model
init =
    { example = FromTo
    }



-- Update


update : Msg -> Model -> Model
update msg model =
    case msg of
        ExampleSelected example ->
            { model | example = example }



-- View


view : Model -> Html Msg
view model =
    layout
        [ width fill
        , padding medium
        ]
        (examples model (buttons model.example))


examples : Model -> Element msg -> Element msg
examples model =
    case model.example of
        FromTo ->
            FromTo.examples

        Steps ->
            Steps.examples

        Sequence ->
            Sequence.examples

        Renderers ->
            Renderers.examples


buttons : Example -> Element Msg
buttons selected =
    [ ( FromTo, "FromTo" )
    , ( Steps, "Steps" )
    , ( Sequence, "Sequence" )
    , ( Renderers, "Renderers" )
    ]
        |> List.map (button selected)
        |> row [ spacing medium ]


button : Example -> ( Example, String ) -> Element Msg
button selected ( ex, label ) =
    el
        [ onClick (ExampleSelected ex)
        , pointer
        , Font.color (highlightNav selected ex)
        ]
        (text label)


highlightNav : Example -> Example -> Color
highlightNav selected ex =
    if selected == ex then
        blue

    else
        black
