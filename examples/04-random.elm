module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Random exposing (Generator, generate, int, pair)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { dieFaceOne : Int
    , dieFaceTwo : Int
    , dieMatch : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( Model 1 3 False, Cmd.none )



-- UPDATE


type Msg
    = Roll
    | NewFace ( Int, Int )


rollTwoDie : Generator ( Int, Int )
rollTwoDie =
    pair (int 1 6) (int 1 6)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, generate NewFace rollTwoDie )

        NewFace ( faceOne, faceTwo ) ->
            ( { model
                | dieFaceOne = faceOne
                , dieFaceTwo = faceTwo
                , dieMatch = faceOne == faceTwo
              }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text (toString model.dieFaceOne) ]
        , h1 [] [ text (toString model.dieFaceTwo) ]
        , h1 [] [ text (toString model.dieMatch) ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]
