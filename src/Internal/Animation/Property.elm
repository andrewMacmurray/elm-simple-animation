module Internal.Animation.Property exposing
    ( Property(..)
    , escape
    , name
    , render
    )

import Internal.Transform as Transform exposing (Transform)
import Set exposing (Set)



-- Property


type Property
    = Opacity Float
    | Transform Transform
    | Raw String String



-- Name


name : Property -> String
name prop =
    case prop of
        Opacity n ->
            "o" ++ rounded 100 n

        Transform t ->
            Transform.name t

        Raw n p ->
            escape n ++ escape p


escape : String -> String
escape =
    String.filter escapedChars


escapedChars : Char -> Bool
escapedChars c =
    not (Set.member c escapedChars_)


escapedChars_ : Set Char
escapedChars_ =
    Set.fromList
        [ '.'
        , ' '
        , ','
        , '#'
        , '$'
        , '%'
        , '('
        , ')'
        , '&'
        , ';'
        , ':'
        , '"'
        , '\''
        , '*'
        , '~'
        , '!'
        , '@'
        , '^'
        , '+'
        , '='
        , '/'
        , '?'
        , '>'
        , '<'
        , '['
        , ']'
        , '{'
        , '}'
        , '|'
        , '`'
        ]


rounded : Int -> Float -> String
rounded n val =
    String.fromInt <| round (val * toFloat n)


render : List Property -> String
render props =
    List.concat
        [ List.map raw_ props
        , [ getProp opacity_ props
          , transform_ props
          ]
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
