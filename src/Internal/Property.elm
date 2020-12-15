module Internal.Property exposing
    ( Property
    , name
    , opacity
    , property
    , render
    , rotate
    , scale
    , scaleXY
    , x
    , xy
    , y
    )

import Internal.Transform as Transform


type Property
    = Opacity Float
    | Y Float
    | X Float
    | XY Float Float
    | Rotate Float
    | ScaleXY Float Float
    | Raw String String


opacity : Float -> Property
opacity =
    Opacity


y : Float -> Property
y =
    Y


x : Float -> Property
x =
    X


xy : Float -> Float -> Property
xy =
    XY


scale : Float -> Property
scale n =
    ScaleXY n n


scaleXY : Float -> Float -> Property
scaleXY =
    ScaleXY


rotate : Float -> Property
rotate =
    Rotate


property : String -> String -> Property
property =
    Raw


name : Property -> String
name prop =
    case prop of
        Opacity n ->
            "o" ++ rounded 100 n

        Y y_ ->
            "y" ++ rounded 1 y_

        X x_ ->
            "x" ++ rounded 1 x_

        Rotate r_ ->
            "r" ++ rounded 1 r_

        ScaleXY x_ y_ ->
            "sx" ++ rounded 100 x_ ++ "sy" ++ rounded 100 y_

        Raw n p ->
            n ++ String.filter (\c -> c /= '.') p

        XY x_ y_ ->
            "x" ++ rounded 1 x_ ++ "y" ++ rounded 1 y_


rounded n val =
    String.fromInt (round val * n)


render : List Property -> String
render props =
    [ getProp opacity_ props
    , getProp raw_ props
    , transform_ props
    ]
        |> filterMaybes
        |> String.join ";"


transform_ : List Property -> Maybe String
transform_ props =
    case collectTransforms props of
        [] ->
            Nothing

        transforms ->
            Just ("transform:" ++ Transform.render transforms)


collectTransforms : List Property -> List Transform.Transform
collectTransforms =
    List.foldl
        (\val acc ->
            case val of
                Y y_ ->
                    Transform.y y_ :: acc

                X x_ ->
                    Transform.x x_ :: acc

                XY x_ y_ ->
                    Transform.xy x_ y_ :: acc

                Rotate r_ ->
                    Transform.rotate r_ :: acc

                ScaleXY x_ y_ ->
                    Transform.scaleXY x_ y_ :: acc

                _ ->
                    acc
        )
        []


opacity_ : Property -> Maybe String
opacity_ p =
    case p of
        Opacity n ->
            Just ("opacity:" ++ String.fromFloat n)

        _ ->
            Nothing


raw_ : Property -> Maybe String
raw_ p =
    case p of
        Raw k v ->
            Just (k ++ ":" ++ v)

        _ ->
            Nothing


getProp : (a -> Maybe b) -> List a -> Maybe b
getProp f =
    List.filterMap f >> List.head


filterMaybes : List (Maybe b) -> List b
filterMaybes =
    List.filterMap identity
