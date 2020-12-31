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

import Internal.Transform as Transform exposing (Transform)



-- Property


type Property
    = Opacity Float
    | Transform Transform
    | Raw String String


opacity : Float -> Property
opacity =
    Opacity


y : Float -> Property
y =
    Transform << Transform.y


x : Float -> Property
x =
    Transform << Transform.x


xy : Float -> Float -> Property
xy x_ y_ =
    Transform (Transform.xy x_ y_)


scale : Float -> Property
scale n =
    Transform (Transform.scaleXY n n)


scaleXY : Float -> Float -> Property
scaleXY x_ y_ =
    Transform (Transform.scaleXY x_ y_)


rotate : Float -> Property
rotate =
    Transform << Transform.rotate


property : String -> String -> Property
property =
    Raw


name : Property -> String
name prop =
    case prop of
        Opacity n ->
            "o" ++ rounded 100 n

        Transform t ->
            Transform.name t

        Raw n p ->
            n ++ String.filter (\c -> c /= '.') p


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
            Just ("transform:" ++ Transform.toString transforms)


collectTransforms : List Property -> List Transform.Transform
collectTransforms =
    List.foldl
        (\val acc ->
            case val of
                Transform t ->
                    t :: acc

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
