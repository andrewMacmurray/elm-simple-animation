module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Events exposing (onClick)
import Element.Font as Font
import Examples.Animations.FromTo as FromTo
import Examples.Animations.Progress as Progress
import Examples.Animations.Renderers as Renderers
import Examples.Animations.Sequence as Sequence
import Examples.Animations.Steps as Steps
import Examples.Transitions.Background as Background
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
    = Animation AnimationExample
    | Transition TransitionExample


type TransitionExample
    = Background


type AnimationExample
    = FromTo
    | Steps
    | Sequence
    | Renderers
    | Progress


type Msg
    = ExampleSelected Example



-- Init


init : Model
init =
    { example = Animation FromTo
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
        Animation FromTo ->
            FromTo.examples

        Animation Steps ->
            Steps.examples

        Animation Sequence ->
            Sequence.examples

        Animation Renderers ->
            Renderers.examples

        Animation Progress ->
            Progress.examples

        Transition Background ->
            Background.examples


buttons : Example -> Element Msg
buttons selected =
    [ animationButtons, transitionButtons ]
        |> List.concat
        |> List.map (button selected)
        |> row [ spacing medium ]


transitionButtons : List ( Example, String )
transitionButtons =
    List.map (Tuple.mapFirst Transition)
        [ ( Background, "Background" )
        ]


animationButtons : List ( Example, String )
animationButtons =
    List.map (Tuple.mapFirst Animation)
        [ ( FromTo, "FromTo" )
        , ( Steps, "Steps" )
        , ( Sequence, "Sequence" )
        , ( Renderers, "Renderers" )
        , ( Progress, "Progress" )
        ]


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
