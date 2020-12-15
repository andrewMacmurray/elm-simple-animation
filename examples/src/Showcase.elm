module Showcase exposing (main)

import Browser
import Element exposing (..)
import Element.Input as Input
import Examples.Dots as Dots
import Examples.Sunflowers as Sunflowers
import Html exposing (Html)
import Utils.UI exposing (medium, small)



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
    = Dots
    | Sunflowers


type Msg
    = ExampleSelected Example



-- Init


init : Model
init =
    { example = Sunflowers
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
    layout [ width fill, padding medium ] (examples model)


examples : Model -> Element Msg
examples model =
    case model.example of
        Dots ->
            Dots.examples buttons

        Sunflowers ->
            Sunflowers.examples buttons


buttons =
    [ ( Dots, "Dots" )
    , ( Sunflowers, "Sunflowers" )
    ]
        |> List.map button
        |> row [ spacing small ]


button ( ex, label ) =
    Input.button []
        { onPress = Just (ExampleSelected ex)
        , label = text label
        }
