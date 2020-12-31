module TransformTest exposing (suite)

import Expect
import Internal.Transform as Transform
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Transforms"
        [ test "Transforms are ordered by `translate`, `scale`, `rotate`" <|
            \_ ->
                [ Transform.scale 5
                , Transform.x 5
                , Transform.y 5
                , Transform.rotate 5
                ]
                    |> Transform.toString
                    |> Expect.equal "translateX(5px) translateY(5px) scale(5,5) rotate(5deg)"
        , test "The last property wins if duplicated" <|
            \_ ->
                [ Transform.rotate 5
                , Transform.x 5
                , Transform.rotate 12
                , Transform.x 10
                ]
                    |> Transform.toString
                    |> Expect.equal "translateX(10px) rotate(12deg)"
        ]
