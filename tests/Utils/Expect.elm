module Utils.Expect exposing
    ( classProperties
    , keyframes
    )

import Expect exposing (Expectation)
import Internal.Animation as Internal
import Simple.Animation exposing (Animation)


classProperties : List String -> Animation -> Expectation
classProperties props anim =
    Internal.classDefinition_ anim
        |> (\def -> List.all (\prop -> String.contains prop def) props)
        |> Expect.true ("unexpected class properties in: \n" ++ Internal.classDefinition_ anim)


keyframes : List String -> Animation -> Expectation
keyframes expected anim =
    Internal.keyframes_ anim
        |> format
        |> Expect.equal (format (String.concat expected))


format : String -> String
format =
    String.filter (\c -> c /= ' ' && c /= '\n')
